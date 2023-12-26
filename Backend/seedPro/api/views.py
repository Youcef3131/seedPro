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
from .permissions import IsAdminOrReadOnly
from django.http import Http404



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
            
        }

        employee_serializer = EmployeeSerializer(data=employee_data)
        if employee_serializer.is_valid():
            employee_serializer.save()
            token, _ = Token.objects.get_or_create(user=user)
            user_data = UserSerializer(user).data
            
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

        # Include shop details in the response
        shop_serializer = ShopSerializer(user.employee.shop)
        response_data = {
            'user': UserSerializer(user).data,
            'shop': shop_serializer.data,
            'token': token.key,
        }

        # Remove sensitive information
        del response_data['user']['password']

        return Response(response_data)

    return Response({"detail": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST)

# @api_view(["POST"])
# def login(request):
#     data = request.data
#     user = authenticate(username=data['username'], password=data['password'])

#     if user:
#         token, created_token = Token.objects.get_or_create(user=user)

#         response_data = {
#             'user': UserSerializer(user).data,
#             'token': token.key,
#         }


#         del response_data['user']['password']

#         return Response(response_data)

#     return Response({"detail": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST)





@api_view(["POST"])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def logout(request):
    try:
       
        request.auth.delete()
        return Response({"message": "Logout was successful"}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# get emplyees


class ListEmployeesView(generics.ListAPIView):
    queryset = Employee.objects.all()
    serializer_class = EmployeeSerializer

# get put employee

class RetrieveUpdateEmployeeView(generics.RetrieveUpdateAPIView):
    queryset = Employee.objects.all()
    serializer_class = EmployeeSerializer
    permission_classes = [IsAdminOrReadOnly]

#add paymant transaction

class AddPaymentTransactionView(generics.CreateAPIView):
    queryset = PaymentTransaction.objects.all()
    serializer_class = PaymentTransactionSerializer
    permission_classes = [IsAdminOrReadOnly]
    def perform_create(self, serializer):
        # Assuming 'employee_id' is passed in the request data
        employee_id = self.request.data.get('employee_id')
        employee = Employee.objects.get(pk=employee_id)
        serializer.save(employee=employee)

#delete payment transaction

class DeletePaymentTransactionView(generics.DestroyAPIView):
    queryset = PaymentTransaction.objects.all()
    serializer_class = PaymentTransactionSerializer
    permission_classes = [IsAdminOrReadOnly]

#add abcence 

class AddAbsenceView(generics.CreateAPIView):
    queryset = Presence.objects.all()
    serializer_class = PresenceSerializer
    def perform_create(self, serializer):
        # Assuming 'employee_id' is passed in the request data
        employee_id = self.request.data.get('employee_id')
        employee = Employee.objects.get(pk=employee_id)
        serializer.save(employee=employee)

#Get Number of Presence in Month

#emplyee infos
#shop
class AddShopView(generics.CreateAPIView):
    queryset = Shop.objects.all()
    serializer_class = ShopSerializer

class ListShopsView(generics.ListAPIView):
    queryset = Shop.objects.all()
    serializer_class = ShopSerializer

#product
class ProductView(APIView):
    def get(self, request, product_id):
        try:
            product = Product.objects.get(pk=product_id)
        except Product.DoesNotExist:
            return Response({"error": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = ProductSerializer(product)
        return Response(serializer.data)

    def post(self, request):
        serializer = ProductSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, product_id):
        try:
            product = Product.objects.get(pk=product_id)
        except Product.DoesNotExist:
            return Response({"error": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = ProductSerializer(product, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, product_id):
        try:
            product = Product.objects.get(pk=product_id)
        except Product.DoesNotExist:
            return Response({"error": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

        product.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class ProductInShopView(APIView):
    def get(self, request, product_in_shop_id):
        try:
            product_in_shop = ProductInShop.objects.get(pk=product_in_shop_id)
        except ProductInShop.DoesNotExist:
            return Response({"error": "Product in shop not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = ProductInShopSerializer(product_in_shop)
        return Response(serializer.data)

    def post(self, request):
        serializer = ProductInShopSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, product_in_shop_id):
        try:
            product_in_shop = ProductInShop.objects.get(pk=product_in_shop_id)
        except ProductInShop.DoesNotExist:
            return Response({"error": "Product in shop not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = ProductInShopSerializer(product_in_shop, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, product_in_shop_id):
        try:
            product_in_shop = ProductInShop.objects.get(pk=product_in_shop_id)
        except ProductInShop.DoesNotExist:
            return Response({"error": "Product in shop not found"}, status=status.HTTP_404_NOT_FOUND)

        product_in_shop.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class ListProductsInCategoryView(generics.ListAPIView):
    serializer_class = ProductSerializer

    def get_queryset(self):
        category_id = self.kwargs['category_id']
        return Product.objects.filter(category_id=category_id)