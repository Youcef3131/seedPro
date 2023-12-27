from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.views import APIView
from django.contrib.auth.models import User
from rest_framework.response import Response
from .serializers import *
from rest_framework import status
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from rest_framework.decorators import authentication_classes, permission_classes
from rest_framework.authentication import TokenAuthentication, SessionAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.response import Response
from rest_framework import status
from .models import *
from rest_framework import generics
from django.http import Http404
from rest_framework.generics import *


#signUp+ add employee login logout
@api_view(["POST"])
def signup(request):
    user_serializer = UserSerializer(data=request.data)
    if user_serializer.is_valid():
        user = user_serializer.save()

        # Create an associated Employee instance
        employee_data = {
            'user': user.id,
            'name': request.data.get('name'),
            'family_name': request.data.get('family_name'),
            'email': request.data.get('email'),
            'username': user.username,
            'password': request.data.get('password'),
            'monthly_salary': request.data.get('monthly_salary'),
            'shop' : request.data.get('shop')
        }

        employee_serializer = EmployeeSerializer(data=employee_data)
        if employee_serializer.is_valid():
            employee_serializer.save()
            token, _ = Token.objects.get_or_create(user=user)
            user_data = UserSerializer(user).data
            # Exclude the 'password' field from the response
            del user_data['password']
            return Response({"user": user_data, "token": token.key}, status=status.HTTP_201_CREATED)
        else:
            user.delete()
            return Response(employee_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    return Response(user_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["POST"])
def login(request):
    data = request.data
    user = authenticate(username=data['username'], password=data['password'])

    if user:
        token, created_token = Token.objects.get_or_create(user=user)

        response_data = {
            'user': UserSerializer(user).data,
            'token': token.key,
        }

        # Exclude the 'password' field from the response
        del response_data['user']['password']

        return Response(response_data)

    return Response({"detail": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST)





@api_view(["POST"])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def logout(request):
    try:
        # Delete the authentication token associated with the user
        request.auth.delete()
        return Response({"message": "Logout was successful"}, status=status.HTTP_200_OK)
    except Exception as e:
        # Handle any exceptions that may occur during logout
        return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)@api_view(["GET"])
def get_shop_by_username(request, username):
    try:
        user = User.objects.get(username=username)
    except User.DoesNotExist:
        return Response({"detail": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Check if the user has an associated employee
    if hasattr(user, 'employee') and user.employee:
        # Serialize the Shop information associated with the Employee
        shop_serializer = ShopSerializer(user.employee.shop)
        return Response({"shop": shop_serializer.data}, status=status.HTTP_200_OK)
    else:
  
        return Response({"detail": "User does not have an associated employee or shop"}, status=status.HTTP_404_NOT_FOUND)

@api_view(["GET"])
def get_shop_by_username(request, username):
    try:
        # First, try to find the user by username
        user = User.objects.get(username=username)
    except User.DoesNotExist:
        return Response({"detail": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Check if the user has an associated employee
    if hasattr(user, 'employee') and user.employee:
        # Return the shop ID in the specified format
        shop_id = user.employee.shop.id
        return Response({"id": shop_id}, status=status.HTTP_200_OK)
    else:
        # If the user does not have an associated employee,
        # try to find the employee by username and get the shop ID
        try:
            employee = Employee.objects.get(username=username)
            shop_id = employee.shop.id
            return Response({"id": shop_id}, status=status.HTTP_200_OK)
        except Employee.DoesNotExist:
            return Response({"detail": "User does not have an associated employee or shop"}, status=status.HTTP_404_NOT_FOUND)

class ListEmployeesView(generics.ListAPIView):
    queryset = Employee.objects.all()
    serializer_class = EmployeeSerializer

# get put employee

class RetrieveUpdateEmployeeView(generics.RetrieveUpdateAPIView):
    queryset = Employee.objects.all()
    serializer_class = EmployeeSerializer
    
class PaymentTransactionCreateView(generics.CreateAPIView):
    queryset = PaymentTransaction.objects.all()
    serializer_class = PaymentTransactionSerializer

    def perform_create(self, serializer):
        employee_id = self.request.data.get('employee')
        employee = Employee.objects.get(pk=employee_id)
        serializer.save(employee=employee)

class PaymentTransactionDeleteView(DestroyAPIView):
    queryset = PaymentTransaction.objects.all()
    serializer_class = PaymentTransactionSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
#add Presence 

class AddPresenceView(generics.CreateAPIView):
    queryset = Presence.objects.all()
    serializer_class = PresenceSerializer
class EmployeePresenceInMonthView(generics.ListAPIView):
    serializer_class = PresenceSerializer

    def get_queryset(self):
        employee_id = self.kwargs['employee_id']
        month = self.kwargs['month']

        # Add any additional validation as needed

        # Retrieve presence entries for the specified employee and month
        return Presence.objects.filter(
            employee_id=employee_id,
            presence_date__month=month
        )

class EmployeePaymentTransactionsView(generics.ListAPIView):
    serializer_class = PaymentTransactionSerializer

    def get_queryset(self):
        # Get the employee_id from the URL parameters
        employee_id = self.kwargs['employee_id']
        return PaymentTransaction.objects.filter(employee_id=employee_id)
#emplyee infos
#shop
class AddShopView(generics.CreateAPIView):
    queryset = Shop.objects.all()
    serializer_class = ShopSerializer

class ListShopsView(generics.ListAPIView):
    queryset = Shop.objects.all()
    serializer_class = ShopSerializer

#product 
class ProductListView(generics.ListCreateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

class ProductDetailView(generics.RetrieveUpdateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

class ShopProductsView(generics.ListAPIView):
    serializer_class = ProductInShopSerializer

    def get_queryset(self):
        shop_id = self.kwargs['shop_id']
        return ProductInShop.objects.filter(shop_id=shop_id)


class ShopProductDetailView(generics.RetrieveAPIView):
    serializer_class = ProductInShopSerializer
    lookup_url_kwarg = 'product_id'  # Specify the expected URL keyword argument
    lookup_field = 'id'  # Specify the model field to use for lookup

    def get_queryset(self):
        shop_id = self.kwargs['shop_id']
        product_id = self.kwargs['product_id']
        return ProductInShop.objects.filter(shop_id=shop_id, product_id=product_id)

#category
class ListProductsInCategoryView(generics.ListAPIView):
    serializer_class = ProductSerializer

    def get_queryset(self):
        category_id = self.kwargs['category_id']
        return Product.objects.filter(category_id=category_id)


#client

class ClientListView(generics.ListCreateAPIView):
    queryset = Client.objects.all()
    serializer_class = ClientSerializer

class ClientDetailView(generics.RetrieveUpdateAPIView):
    queryset = Client.objects.all()
    serializer_class = ClientSerializer

class ShopClientsView(APIView):
    def get(self, request, shop_id):
        clients = Client.objects.filter(shop_id=shop_id)
        serializer = ClientSerializer(clients, many=True)
        return Response(serializer.data)


class SupplierListView(generics.ListCreateAPIView):
    queryset = Supplier.objects.all()
    serializer_class = SupplierSerializer

class SupplierDetailView(generics.RetrieveUpdateAPIView):
    queryset = Supplier.objects.all()
    serializer_class = SupplierSerializer


class ShopSuppliersView(APIView):
    def get(self, request, shop_id):
        suppliers = Supplier.objects.filter(shop_id=shop_id)
        serializer = SupplierSerializer(suppliers, many=True)
        return Response(serializer.data)
        
class CoastsListView(generics.ListCreateAPIView):
    queryset = Coasts.objects.all()
    serializer_class = CoastsSerializer

class CoastsDetailView(generics.RetrieveUpdateAPIView):
    queryset = Coasts.objects.all()
    serializer_class = CoastsSerializer



class ShopCoastsView(APIView):
    def get(self, request, shop_id):
        coasts = Coasts.objects.filter(shop_id=shop_id)
        serializer = CoastsSerializer(coasts, many=True)
        return Response(serializer.data)