from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.permissions import AllowAny
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
from django.db.models.functions import *

#signUp+ add employee login logout
@api_view(["POST"])
@permission_classes([AllowAny])
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
@permission_classes([AllowAny])
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

@api_view(["GET"])
@permission_classes([IsAuthenticated])
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


class RetrieveEmployeeView(generics.RetrieveAPIView):
    queryset = Employee.objects.all()
    serializer_class = EmployeeSerializer

    def get_object(self):
        username = self.kwargs['username']
        try:
            return Employee.objects.get(username=username)
        except Employee.DoesNotExist:
            raise Http404

            
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

class RetrieveShopView(generics.RetrieveAPIView):
    queryset = Shop.objects.all()
    serializer_class = ShopSerializer
#product 
class ProductListView(generics.ListCreateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

class ProductDetailView(generics.RetrieveUpdateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer


class ProductInShopListCreateView(generics.ListCreateAPIView):
    queryset = ProductInShop.objects.all()
    serializer_class = ProductInShopSerializer

class ShopProductsView(generics.ListAPIView):
    serializer_class = ProductInShopSerializer

    def get_queryset(self):
        shop_id = self.kwargs['shop_id']
        return ProductInShop.objects.filter(shop_id=shop_id)

class ProductInShopListView(generics.ListAPIView):
    serializer_class = ProductWithQuantitySerializer

    def get_queryset(self):
        shop_id = self.kwargs.get('shop_id')
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
#############################################################################################        


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

class ClientsWithUnpaidSalesView(APIView):
    def get(self, request, shop_id, format=None):
        unpaid_clients = []

        # Retrieve the shop details
        try:
            shop = Shop.objects.get(pk=shop_id)
        except Shop.DoesNotExist:
            return Response({'error': 'Shop not found'}, status=status.HTTP_404_NOT_FOUND)

        # Retrieve all sales for the specified shop
        sales = Sale.objects.filter(client__shop_id=shop_id)

        # Iterate over each sale
        for sale in sales:
            # Calculate the total amount of products sold in this sale
            total_sale_amount = sum(product.quantity_sold * product.product.saleing_price for product in sale.sale_products.all())

            # Compare with the amountPaid for the associated sale
            if sale.amountPaid < total_sale_amount:
                unpaid_clients.append({
                    'client_name': f'{sale.client.name} {sale.client.family_name}',
                    'shop_details': shop_id,
                    'sale_details': SaleSerializer(sale).data,
                    'total_sale_amount': total_sale_amount,
                    'amount_paid': float(sale.amountPaid),  # Convert to float for consistency
                })

        return Response(unpaid_clients, status=status.HTTP_200_OK)
class SuppliersWithUnpaidPurchasesView(APIView):
    def get(self, request, shop_id, format=None):
        unpaid_suppliers = []

        # Retrieve the shop details
        try:
            shop = Shop.objects.get(pk=shop_id)
        except Shop.DoesNotExist:
            return Response({'error': 'Shop not found'}, status=status.HTTP_404_NOT_FOUND)

        # Retrieve all purchases for the specified shop
        purchases = Purchase.objects.filter(supplier__shop_id=shop_id)

        # Iterate over each purchase
        for purchase in purchases:
            # Calculate the total amount of products purchased in this purchase
            total_purchase_amount = sum(
                product.quantity_purchased * product.product.buying_price for product in purchase.purchaseproduct_set.all()
            )

            # Compare with the amountPaidToSupplier for the associated purchase
            if purchase.amountPaidToSupplier < total_purchase_amount:
                unpaid_suppliers.append({
                    'supplier_name': f'{purchase.supplier.name} {purchase.supplier.family_name}',
                    'shop_id': shop.id,
                    'purchase_details': PurchaseSerializer(purchase).data,
                    'total_purchase_amount': total_purchase_amount,
                    'amount_paid_to_supplier': float(purchase.amountPaidToSupplier),  # Convert to float for consistency
                })

        return Response(unpaid_suppliers, status=status.HTTP_200_OK)





#sale
# views.py
class SaleListCreateView(generics.ListCreateAPIView):
    queryset = Sale.objects.all()
    serializer_class = SaleSerializer



########################################################################
class SaleRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Sale.objects.all()
    serializer_class = SaleSerializer

    def perform_destroy(self, instance):
        try:
            # Adjust ProductInShop on Sale deletion
            self.adjust_product_in_shop_on_delete(instance)
            instance.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Sale.DoesNotExist:
            return Response({"error": "Sale not found."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def adjust_product_in_shop_on_delete(self, sale):
        for sale_product in sale.sale_products.all():
            product = sale_product.product
            product_in_shop = get_object_or_404(ProductInShop, shop=sale.client.shop, product=product)
            product_in_shop.quantity += sale_product.quantity_sold
            product_in_shop.save()


########################################################################
class SaleProductListCreateView(generics.ListCreateAPIView):
    queryset = SaleProduct.objects.all()
    serializer_class = SaleProductSerializer

    def perform_create(self, serializer):
        # Adjust ProductInShop on SaleProduct creation
        sale_product = serializer.save()
        self.adjust_product_in_shop_on_create(sale_product)

    def adjust_product_in_shop_on_create(self, sale_product):
        product = sale_product.product
        product_in_shop, created = ProductInShop.objects.get_or_create(shop=sale_product.sale.client.shop, product=product)
        product_in_shop.quantity -= sale_product.quantity_sold
        product_in_shop.save()
        
########################################################################
class SaleProductRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = SaleProduct.objects.all()
    serializer_class = SaleProductSerializer

    def perform_update(self, serializer):
        old_instance = SaleProduct.objects.get(pk=self.kwargs['pk'])

        # Store the old quantity before saving the new instance
        old_quantity = old_instance.quantity_sold
        new_instance = serializer.save()

        # Calculate the difference in quantities
        quantity_difference = old_quantity - new_instance.quantity_sold

        # Adjust ProductInShop based on the quantity difference
        self.adjust_product_in_shop_on_update(new_instance, quantity_difference)

        return Response(serializer.data)

    def perform_destroy(self, instance):
        # Adjust ProductInShop on SaleProduct deletion
        self.adjust_product_in_shop_on_delete(instance)
        instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

    def adjust_product_in_shop_on_update(self, sale_product, quantity_difference):
        product = sale_product.product
        product_in_shop = get_object_or_404(ProductInShop, shop=sale_product.sale.client.shop, product=product)
        
        # Adjust ProductInShop based on the quantity difference
        product_in_shop.quantity += quantity_difference
        product_in_shop.save()

    def adjust_product_in_shop_on_delete(self, sale_product):
        product = sale_product.product
        product_in_shop = get_object_or_404(ProductInShop, shop=sale_product.sale.client.shop, product=product)
        product_in_shop.quantity += sale_product.quantity_sold
        product_in_shop.save()

########################################################################

class SaleListByShopView(generics.ListAPIView):
    serializer_class = SaleSerializer

    def get_queryset(self):
        shop_id = self.kwargs.get('shop_id')
        return Sale.objects.filter(client__shop__id=shop_id)

class AllSalesInfoView(APIView):
    def get(self, request, shop_id):
        # Retrieve sales data for the given shop_id
        sales = Sale.objects.filter(client__shop_id=shop_id)

        # Serialize the data using SaleInfoSerializer
        serializer = SaleInfoSerializer(sales, many=True)

        # Return the serialized data as a JSON response
        return Response(serializer.data, status=status.HTTP_200_OK)

class SaleProductDetailView(APIView):

    def get(self, request, sale_id):
        # Retrieve sale products for the given sale_id
        sale_products = SaleProduct.objects.filter(sale_id=sale_id)

        # Serialize the data using SaleProductDetailSerializer
        serializer = SaleProductDetailSerializer(sale_products, many=True)

        # Return the serialized data as a JSON response
        return Response(serializer.data, status=status.HTTP_200_OK)


class AllPurchasesInfoView(APIView):
    def get(self, request, shop_id):
        # Retrieve purchase data for the given shop_id
        purchases = Purchase.objects.filter(supplier__shop_id=shop_id)

        # Serialize the data using PurchaseInfoSerializer
        serializer = PurchaseInfoSerializer(purchases, many=True)

        # Return the serialized data as a JSON response
        return Response(serializer.data, status=status.HTTP_200_OK)

        
class SaleListByClientView(generics.ListAPIView):
    serializer_class = SaleSerializer

    def get_queryset(self):
        client_id = self.kwargs.get('client_id')
        return Sale.objects.filter(client__id=client_id)

class SaleProductListBySaleView(generics.ListAPIView):
    serializer_class = SaleProductSerializer

    def get_queryset(self):
        sale_id = self.kwargs.get('sale_id')
        return SaleProduct.objects.filter(sale__id=sale_id)

#sale payment

# views.py
class SalePaymentListCreateView(generics.ListCreateAPIView):
    serializer_class = SalePaymentSerializer

    def get_queryset(self):
        return SalePayment.objects.all()

    def perform_create(self, serializer):
        try:
            sale_payment = serializer.save()

            # Update the associated sale's amountPaid
            sale = sale_payment.sale
            sale.amountPaid += sale_payment.amount
            sale.save()

            return Response(serializer.data, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



class SalePaymentRetrieveDestroyView(generics.RetrieveDestroyAPIView):
    queryset = SalePayment.objects.all()
    serializer_class = SalePaymentSerializer

    def perform_destroy(self, instance):
        try:
            # Update the associated sale's amountPaid before deletion
            sale = instance.sale
            sale.amountPaid -= instance.amount
            sale.save()

            instance.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class SaleTotalView(APIView):
    def post(self, request, *args, **kwargs):
        try:
            sale = request.data.get('sale')
            
            # Validate that the sale_id is provided
            if sale is None:
                raise ValueError('Sale ID is required in the request data.')

            sale = Sale.objects.get(pk=sale)
            
            # Calculate the total based on SaleProduct items
            total = 0
            for sale_product in sale.sale_products.all():
                total += sale_product.quantity_sold * sale_product.product.saleing_price
            
            # Update the Sale model with the calculated total
            sale.amountPaid = total
            sale.save()

            # Return the total as JSON
            return Response({'total': total}, status=status.HTTP_200_OK)

        except Sale.DoesNotExist:
            return Response({'error': 'Sale not found'}, status=status.HTTP_404_NOT_FOUND)
        except ValueError as ve:
            return Response({'error': str(ve)}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



#purshase 

class PurchaseListCreateView(generics.ListCreateAPIView):
    queryset = Purchase.objects.all()
    serializer_class = PurchaseSerializer

class PurchaseRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Purchase.objects.all()
    serializer_class = PurchaseSerializer

    def perform_destroy(self, instance):
        try:
            # Adjust ProductInShop on Purchase deletion
            self.adjust_product_in_shop_on_delete(instance)
            instance.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Purchase.DoesNotExist:
            return Response({"error": "Purchase not found."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def adjust_product_in_shop_on_delete(self, purchase):
        for purchase_product in purchase.purchaseproduct_set.all():
            product = purchase_product.product
            product_in_shop = get_object_or_404(ProductInShop, shop=purchase.supplier.shop, product=product)
            product_in_shop.quantity -= purchase_product.quantity_purchased
            product_in_shop.save()

class PurchaseProductListCreateView(generics.ListCreateAPIView):
    queryset = PurchaseProduct.objects.all()
    serializer_class = PurchaseProductSerializer

    def perform_create(self, serializer):
        # Adjust ProductInShop on PurchaseProduct creation
        purchase_product = serializer.save()
        self.adjust_product_in_shop_on_create(purchase_product)

    def adjust_product_in_shop_on_create(self, purchase_product):
        product = purchase_product.product
        product_in_shop, created = ProductInShop.objects.get_or_create(shop=purchase_product.purchase.supplier.shop, product=product)
        product_in_shop.quantity += purchase_product.quantity_purchased
        product_in_shop.save()

class PurchaseProductDetailView(APIView):
    def get(self, request, purchase_id):
        # Retrieve purchase products for the given purchase_id
        purchase_products = PurchaseProduct.objects.filter(purchase_id=purchase_id)

        # Serialize the data using PurchaseProductDetailSerializer
        serializer = PurchaseProductDetailSerializer(purchase_products, many=True)

        # Return the serialized data as a JSON response
        return Response(serializer.data, status=status.HTTP_200_OK)
        
class PurchaseProductRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = PurchaseProduct.objects.all()
    serializer_class = PurchaseProductSerializer

    def perform_update(self, serializer):
        old_instance = PurchaseProduct.objects.get(pk=self.kwargs['pk'])

        # Store the old quantity before saving the new instance
        old_quantity = old_instance.quantity_purchased
        new_instance = serializer.save()

        # Calculate the difference in quantities
        quantity_difference = old_quantity - new_instance.quantity_purchased

        # Adjust ProductInShop based on the quantity difference
        self.adjust_product_in_shop_on_update(new_instance, quantity_difference)

        return Response(serializer.data)

    def perform_destroy(self, instance):
        # Adjust ProductInShop on PurchaseProduct deletion
        self.adjust_product_in_shop_on_delete(instance)
        instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

    def adjust_product_in_shop_on_update(self, purchase_product, quantity_difference):
        product = purchase_product.product
        product_in_shop = get_object_or_404(ProductInShop, shop=purchase_product.purchase.supplier.shop, product=product)
        
        # Adjust ProductInShop based on the quantity difference
        product_in_shop.quantity -= quantity_difference
        product_in_shop.save()

    def adjust_product_in_shop_on_delete(self, purchase_product):
        product = purchase_product.product
        product_in_shop = get_object_or_404(ProductInShop, shop=purchase_product.purchase.supplier.shop, product=product)
        
        # Adjust ProductInShop based on the quantity purchased during the purchase product
        product_in_shop.quantity -= purchase_product.quantity_purchased
        product_in_shop.save()

class PurchaseListByShopView(generics.ListAPIView):
    serializer_class = PurchaseSerializer

    def get_queryset(self):
        shop_id = self.kwargs['shop_id']
        return Purchase.objects.filter(supplier__shop_id=shop_id)

class PurchaseListBySupplierView(generics.ListAPIView):
    serializer_class = PurchaseSerializer

    def get_queryset(self):
        supplier_id = self.kwargs['supplier_id']
        return Purchase.objects.filter(supplier_id=supplier_id)


class PurchaseProductListByPurchaseView(generics.ListAPIView):
    serializer_class = PurchaseProductSerializer

    def get_queryset(self):
        purchase_id = self.kwargs['purchase_id']
        return PurchaseProduct.objects.filter(purchase_id=purchase_id)
class PurchasePaymentListCreateView(generics.ListCreateAPIView):
    serializer_class = PurchasePaymentSerializer

    def get_queryset(self):
        return PurchasePayment.objects.all()

    def perform_create(self, serializer):
        try:
            purchase_payment = serializer.save()

            # Update the associated purchase's amountPaidToSupplier
            purchase = purchase_payment.purchase
            purchase.amountPaidToSupplier += purchase_payment.amount
            purchase.save()

            return Response(serializer.data, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class PurchasePaymentRetrieveDestroyView(generics.RetrieveDestroyAPIView):
    queryset = PurchasePayment.objects.all()
    serializer_class = PurchasePaymentSerializer

    def perform_destroy(self, instance):
        try:
            # Update the associated purchase's amountPaidToSupplier before deletion
            purchase = instance.purchase
            purchase.amountPaidToSupplier -= instance.amount
            purchase.save()

            instance.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class PurchaseTotalView(APIView):
    def post(self, request, *args, **kwargs):
        try:
            purchase = request.data.get('purchase')
            
            # Validate that the purchase_id is provided
            if purchase is None:
                raise ValueError('Purchase ID is required in the request data.')

            purchase = Purchase.objects.get(pk=purchase)
            
            # Calculate the total based on PurchaseProduct items
            total = 0
            for purchase_product in purchase.purchase_products.all():
                total += purchase_product.quantity_purchased * purchase_product.product.buying_price
            
            # Update the Purchase model with the calculated total
            purchase.amountPaidToSupplier = total
            purchase.save()

            # Return the total as JSON
            return Response({'total': total}, status=status.HTTP_200_OK)

        except Purchase.DoesNotExist:
            return Response({'error': 'Purchase not found'}, status=status.HTTP_404_NOT_FOUND)
        except ValueError as ve:
            return Response({'error': str(ve)}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)






#trensfer 
class TransferListCreateView(generics.ListCreateAPIView):
    queryset = Transfer.objects.all()
    serializer_class = TransferSerializer

class TransferRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Transfer.objects.all()
    serializer_class = TransferSerializer

    def perform_destroy(self, instance):
        # Iterate through TransferItems and adjust product quantities in both source and destination shops
        for transfer_item in instance.transfer_items.all():  # Use the related manager
            product = transfer_item.product
            quantity = transfer_item.quantity
            source_shop_product = ProductInShop.objects.get(shop=instance.source_shop, product=product)
            destination_shop_product = ProductInShop.objects.get(shop=instance.dest_shop, product=product)
            source_shop_product.quantity += quantity
            destination_shop_product.quantity -= quantity
            source_shop_product.save()
            destination_shop_product.save()

        instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class TransferItemListCreateView(generics.ListCreateAPIView):
    serializer_class = TransferItemSerializer

    def get_queryset(self):
        transfer_id = self.kwargs['transfer_id']
        return TransferItem.objects.filter(transfer_id=transfer_id)

    def perform_create(self, serializer):
        transfer_id = self.kwargs['transfer_id']
        transfer = get_object_or_404(Transfer, pk=transfer_id)
        serializer.save(transfer=transfer)

        # Adjust product quantities in both source and destination shops
        product = serializer.validated_data['product']
        quantity = serializer.validated_data['quantity']
        source_shop_product = ProductInShop.objects.get(shop=transfer.source_shop, product=product)
        destination_shop_product, created = ProductInShop.objects.get_or_create(shop=transfer.dest_shop, product=product)
        source_shop_product.quantity -= quantity
        destination_shop_product.quantity += quantity
        source_shop_product.save()
        destination_shop_product.save()

class TransferItemRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = TransferItem.objects.all()
    serializer_class = TransferItemSerializer

    def perform_update(self, serializer):
        old_instance = TransferItem.objects.get(pk=self.kwargs['pk'])
        old_quantity = old_instance.quantity
        serializer.save()

        # Adjust product quantities in both source and destination shops
        product = old_instance.product
        new_quantity = serializer.validated_data['quantity']
        source_shop_product = ProductInShop.objects.get(shop=old_instance.transfer.source_shop, product=product)
        destination_shop_product = ProductInShop.objects.get(shop=old_instance.transfer.dest_shop, product=product)
        source_shop_product.quantity += old_quantity  # Undo the previous quantity
        destination_shop_product.quantity -= old_quantity  # Undo the previous quantity
        source_shop_product.quantity -= new_quantity
        destination_shop_product.quantity += new_quantity
        source_shop_product.save()
        destination_shop_product.save()

    def perform_destroy(self, instance):
        # Adjust product quantities in both source and destination shops
        product = instance.product
        quantity = instance.quantity
        source_shop_product = ProductInShop.objects.get(shop=instance.transfer.source_shop, product=product)
        destination_shop_product = ProductInShop.objects.get(shop=instance.transfer.dest_shop, product=product)
        source_shop_product.quantity += quantity
        destination_shop_product.quantity -= quantity
        source_shop_product.save()
        destination_shop_product.save()
        instance.delete()




class CalculateTransferTotalView(generics.RetrieveAPIView):
    queryset = Transfer.objects.all()
    serializer_class = TransferSerializer

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        total = calculate_transfer_total(instance)
        return Response({"total": total})


def calculate_transfer_total(transfer):
    total = 0

    for transfer_item in transfer.transfer_items.all():
        product = transfer_item.product
        quantity = transfer_item.quantity
        buying_price = product.buying_price

        total += quantity * buying_price

    return total



class CompositionListCreateView(generics.ListCreateAPIView):
    queryset = Composition.objects.all()
    serializer_class = CompositionSerializer

    def perform_create(self, serializer):
        # Save the composition first
        composition = serializer.save()

        # Adjust product quantities in the shop
        output_product = composition.output_product
        quantity_composed = composition.quantity_composed
        shop = composition.shop

        # Adjust the output product quantity
        output_product_in_shop, created = ProductInShop.objects.get_or_create(shop=shop, product=output_product)
        output_product_in_shop.quantity += quantity_composed
        output_product_in_shop.save()

        # Adjust input product quantities
        input_products = composition.input_products.all()
        for input_product in input_products:
            input_product_in_shop, created = ProductInShop.objects.get_or_create(shop=shop, product=input_product)
            input_product_in_shop.quantity -= quantity_composed
            input_product_in_shop.save()


class CompositionRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Composition.objects.all()
    serializer_class = CompositionSerializer

    def perform_update(self, serializer):
        old_instance = Composition.objects.get(pk=self.kwargs['pk'])
        old_quantity_composed = old_instance.quantity_composed
        serializer.save()

        # Calculate the difference in quantity
        new_quantity_composed = serializer.validated_data['quantity_composed']
        quantity_difference = new_quantity_composed - old_quantity_composed

        # Adjust product quantities in the shop
        shop = old_instance.shop

        # Adjust the output product quantity
        output_product = old_instance.output_product
        output_product_in_shop = ProductInShop.objects.get(shop=shop, product=output_product)
        output_product_in_shop.quantity += quantity_difference
        output_product_in_shop.save()

        # Adjust input product quantities
        input_products = old_instance.input_products.all()
        for input_product in input_products:
            input_product_in_shop = ProductInShop.objects.get(shop=shop, product=input_product)
            input_product_in_shop.quantity -= quantity_difference
            input_product_in_shop.save()


    def perform_destroy(self, instance):
        # Adjust product quantities in the shop
        output_product = instance.output_product
        quantity_composed = instance.quantity_composed
        shop = instance.shop

        output_product_in_shop = ProductInShop.objects.get(shop=shop, product=output_product)
        output_product_in_shop.quantity -= quantity_composed
        output_product_in_shop.save()

        # Adjust input product quantities
        input_products = instance.input_products.all()
        for input_product in input_products:
            input_product_in_shop = ProductInShop.objects.get(shop=shop, product=input_product)
            input_product_in_shop.quantity += quantity_composed
            input_product_in_shop.save()

        instance.delete()



#dashbord
from django.db.models import *


class TopClientsPerYearView(APIView):
    def get(self, request, shop_id):
        # Get the current year
        current_year = timezone.now().year

        # Validate and retrieve the shop
        try:
            shop = Shop.objects.get(pk=shop_id)
        except Shop.DoesNotExist:
            return JsonResponse({'error': 'Shop does not exist.'}, status=404)

        # Calculate the total sales value for each client in the current year
        top_clients = Client.objects.filter(shop=shop).annotate(
            total_sales_value=Sum('sale__sale_products__quantity_sold', filter=Q(sale__date__year=current_year))
        ).order_by('-total_sales_value')[:5]

        # Serialize the data and return the response
        serializer = ClientSerializer(top_clients, many=True)
        return Response(serializer.data)



class TopClientsPerMonthView(APIView):
    def get(self, request, shop_id):
        # Get the current month and year
        current_month = timezone.now().month
        current_year = timezone.now().year

        # Validate and retrieve the shop
        try:
            shop = Shop.objects.get(pk=shop_id)
        except Shop.DoesNotExist:
            return JsonResponse({'error': 'Shop does not exist.'}, status=404)

        # Calculate the total sales value for each client in the current month
        top_clients = Client.objects.filter(shop=shop).annotate(
            total_sales_value=Sum('sale__sale_products__quantity_sold', 
                                  filter=Q(sale__date__month=current_month, sale__date__year=current_year))
        ).order_by('-total_sales_value')[:5]

        # Serialize the data and return the response
        serializer = ClientSerializer(top_clients, many=True)
        return Response(serializer.data)


class TopSuppliersPerMonthView(APIView):
    def get(self, request, shop_id):
        # Get the current month and year
        current_month = timezone.now().month
        current_year = timezone.now().year

        # Validate and retrieve the shop
        try:
            shop = Shop.objects.get(pk=shop_id)
        except Shop.DoesNotExist:
            return JsonResponse({'error': 'Shop does not exist.'}, status=404)

        # Calculate the total purchase value for each supplier in the current month
        top_suppliers = Supplier.objects.filter(shop=shop).annotate(
            total_purchase_value=Sum('purchase__purchaseproduct__quantity_purchased', 
                                     filter=Q(purchase__date__month=current_month, purchase__date__year=current_year))
        ).order_by('-total_purchase_value')[:5]

        # Serialize the data and return the response
        serializer = SupplierSerializer(top_suppliers, many=True)
        return Response(serializer.data)

    

class TopSuppliersPerYearView(APIView):
    def get(self, request, shop_id):
        # Get the current year
        current_year = timezone.now().year

        # Validate and retrieve the shop
        try:
            shop = Shop.objects.get(pk=shop_id)
        except Shop.DoesNotExist:
            return JsonResponse({'error': 'Shop does not exist.'}, status=404)

        # Calculate the total purchase value for each supplier in the current year
        top_suppliers = Supplier.objects.filter(shop=shop).annotate(
            total_purchase_value=Sum('purchase__purchaseproduct__quantity_purchased', 
                                     filter=Q(purchase__date__year=current_year))
        ).order_by('-total_purchase_value')[:5]

        # Serialize the data and return the response
        serializer = SupplierSerializer(top_suppliers, many=True)
        return Response(serializer.data)






class BestSellingProductsView(APIView):
    def get(self, request, shop_id):
        try:
            shop = Shop.objects.get(pk=shop_id)
        except Shop.DoesNotExist:
            return Response({'error': 'Shop not found.'}, status=404)

        # Get the quantity of each product sold in the specified shop
        product_quantities = SaleProduct.objects.filter(sale__client__shop=shop) \
            .values('product') \
            .annotate(total_sold=Sum('quantity_sold')) \
            .order_by('-total_sold')[:5]  # Limit to the top 5 best-selling products

        # Fetch the corresponding Product instances and serialize the data
        best_selling_products_data = []
        for product_quantity in product_quantities:
            product_id = product_quantity['product']
            quantity_sold = product_quantity['total_sold']
            product = Product.objects.get(pk=product_id)

            # Serialize product data
            serializer = ProductSerializer(product)
            product_data = serializer.data

            # Include quantity sold in the response
            product_data['quantity_sold'] = quantity_sold
            best_selling_products_data.append(product_data)

        return Response(best_selling_products_data)





























        










class PurchaseEvolutionMonthView(APIView):
    def get(self, request, shop_id):
        try:
            # Assuming you have a Shop model and 'id' is the primary key
            shop = Shop.objects.get(id=shop_id)
        except Shop.DoesNotExist:
            return Response({'error': 'Shop not found.'}, status=404)

        # Calculate total purchases for the current month
        current_month = timezone.now().month
        current_year = timezone.now().year

        total_purchase_current_month = Purchase.objects.filter(
            date__month=current_month,
            date__year=current_year,
            supplier__shop=shop
        ).aggregate(
            total_purchase_current_month=Coalesce(
                Sum(F('purchaseproduct__quantity_purchased') * F('purchaseproduct__product__buying_price')),
                0,
                output_field=DecimalField()
            )
        )['total_purchase_current_month']

        # Calculate total purchases for the previous month
        previous_month = (current_month - 1) if current_month > 1 else 12
        previous_year = current_year if current_month > 1 else (current_year - 1)

        total_purchase_previous_month = Purchase.objects.filter(
            date__month=previous_month,
            date__year=previous_year,
            supplier__shop=shop
        ).aggregate(
            total_purchase_previous_month=Coalesce(
                Sum(F('purchaseproduct__quantity_purchased') * F('purchaseproduct__product__buying_price')),
                0,
                output_field=DecimalField()
            )
        )['total_purchase_previous_month']

        # Calculate the evolution rate
        evolution_rate_month_purchase = (
            (total_purchase_current_month - total_purchase_previous_month) / total_purchase_previous_month
        ) * 100 if total_purchase_previous_month != 0 else 0

        response_data = {
            'total_purchase_current_month': total_purchase_current_month,
            'total_purchase_previous_month': total_purchase_previous_month,
            'evolution_rate_month_purchase': evolution_rate_month_purchase,
        }

        return Response(response_data)



class PurchaseEvolutionYearView(APIView):
    def get(self, request, shop_id):
        try:
            shop = Shop.objects.get(id=shop_id)
        except Shop.DoesNotExist:
            return Response({'error': 'Shop not found.'}, status=404)

        # Calculate total purchases for the current year
        current_year = timezone.now().year

        total_purchase_current_year = Purchase.objects.filter(
            date__year=current_year,
            supplier__shop=shop
        ).aggregate(
            total_purchase_current_year=Coalesce(
                Sum(F('purchaseproduct__quantity_purchased') * F('purchaseproduct__product__buying_price')),
                0,
                output_field=DecimalField()
            )
        )['total_purchase_current_year']

        # Calculate total purchases for the previous year
        previous_year = current_year - 1

        total_purchase_previous_year = Purchase.objects.filter(
            date__year=previous_year,
            supplier__shop=shop
        ).aggregate(
            total_purchase_previous_year=Coalesce(
                Sum(F('purchaseproduct__quantity_purchased') * F('purchaseproduct__product__buying_price')),
                0,
                output_field=DecimalField()
            )
        )['total_purchase_previous_year']

        # Calculate the evolution rate
        evolution_rate_year_purchase = (
            (total_purchase_current_year - total_purchase_previous_year) / total_purchase_previous_year
        ) * 100 if total_purchase_previous_year != 0 else 0

        response_data = {
            'total_purchase_current_year': total_purchase_current_year,
            'total_purchase_previous_year': total_purchase_previous_year,
            'evolution_rate_year_purchase': evolution_rate_year_purchase,
        }

        return Response(response_data)




class SalesEvolutionMonthView(APIView):
    def get(self, request, shop_id):
        try:
            shop = Shop.objects.get(id=shop_id)
        except Shop.DoesNotExist:
            return Response({'error': 'Shop not found.'}, status=404)

        # Calculate total sales for the current month
        current_month = timezone.now().month
        current_year = timezone.now().year

        total_sales_current_month = Sale.objects.filter(
            date__month=current_month,
            date__year=current_year,
            client__shop=shop
        ).aggregate(
            total_sales_current_month=Coalesce(
                Sum(F('sale_products__quantity_sold') * F('sale_products__product__saleing_price')),
                0,
                output_field=DecimalField()
            )
        )['total_sales_current_month']

        # Calculate total sales for the previous month
        previous_month = (current_month - 1) if current_month > 1 else 12
        previous_year = current_year if current_month > 1 else (current_year - 1)

        total_sales_previous_month = Sale.objects.filter(
            date__month=previous_month,
            date__year=previous_year,
            client__shop=shop
        ).aggregate(
            total_sales_previous_month=Coalesce(
                Sum(F('sale_products__quantity_sold') * F('sale_products__product__saleing_price')),
                0,
                output_field=DecimalField()
            )
        )['total_sales_previous_month']

        # Calculate the evolution rate
        evolution_rate_month_sales = (
            (total_sales_current_month - total_sales_previous_month) / total_sales_previous_month
        ) * 100 if total_sales_previous_month != 0 else 0

        response_data = {
            'total_sales_current_month': total_sales_current_month,
            'total_sales_previous_month': total_sales_previous_month,
            'evolution_rate_month_sales': evolution_rate_month_sales,
        }

        return Response(response_data)
    


class SalesEvolutionYearView(APIView):
    def get(self, request, shop_id):
        try:
            shop = Shop.objects.get(id=shop_id)
        except Shop.DoesNotExist:
            return Response({'error': 'Shop not found.'}, status=404)

        # Calculate total sales for the current year
        current_year = timezone.now().year

        total_sales_current_year = Sale.objects.filter(
            date__year=current_year,
            client__shop=shop
        ).aggregate(
            total_sales_current_year=Coalesce(
                Sum(F('sale_products__quantity_sold') * F('sale_products__product__saleing_price')),
                0,
                output_field=DecimalField()
            )
        )['total_sales_current_year']

        # Calculate total sales for the previous year
        previous_year = current_year - 1

        total_sales_previous_year = Sale.objects.filter(
            date__year=previous_year,
            client__shop=shop
        ).aggregate(
            total_sales_previous_year=Coalesce(
                Sum(F('sale_products__quantity_sold') * F('sale_products__product__saleing_price')),
                0,
                output_field=DecimalField()
            )
        )['total_sales_previous_year']

        # Calculate the evolution rate
        evolution_rate_year_sales = (
            (total_sales_current_year - total_sales_previous_year) / total_sales_previous_year
        ) * 100 if total_sales_previous_year != 0 else 0

        response_data = {
            'total_sales_current_year': total_sales_current_year,
            'total_sales_previous_year': total_sales_previous_year,
            'evolution_rate_year_sales': evolution_rate_year_sales,
        }

        return Response(response_data)










from datetime import *


class ShopSalesLast5DaysAPIView(APIView):
    def get(self, request, shop_id):
        # Calculate the date 5 days ago from today
        start_date = datetime.now() - timedelta(days=5)

        # Query the sales for the specified shop in the last 5 days
        sales_last_5_days = Sale.objects.filter(
            date__gte=start_date,
            client__shop_id=shop_id
        )

        # Calculate sales per day
        sales_per_day = sales_last_5_days.values('date__date').annotate(count=Count('id')).order_by('-date__date')

        # Get an array of sales count per day starting with the latest day
        sales_count_per_day = [entry['count'] for entry in sales_per_day]

        return Response(sales_count_per_day)

from django.utils import timezone
class ProfitEvolutionYearView(APIView):
    def get(self, request, shop_id):
        try:
            shop = Shop.objects.get(id=shop_id)
        except Shop.DoesNotExist:
            return Response({'error': 'Shop not found.'}, status=404)

        current_year = timezone.now().year

        total_sales_current_year = Sale.objects.filter(
            date__year=current_year,
            client__shop=shop
        ).aggregate(
            total_sales_current_year=Coalesce(
                Sum(F('sale_products__quantity_sold') * F('sale_products__product__saleing_price')),
                0,
                output_field=DecimalField()
            )
        )['total_sales_current_year']

        total_transfers_current_year = Transfer.objects.filter(
            date__year=current_year,
            source_shop=shop
        ).aggregate(
            total_transfers_current_year=Coalesce(
                Sum(F('transfer_items__quantity') * F('transfer_items__product__buying_price')),
                0,
                output_field=DecimalField()
            )
        )['total_transfers_current_year']

        total_costs_current_year = Coasts.objects.filter(
            date__year=current_year,
            shop=shop
        ).aggregate(
            total_costs_current_year=Sum('amount')
        )['total_costs_current_year'] or 0

        total_employee_payments_current_year = shop.employee_set.filter(
            paymenttransaction__transaction_date__year=current_year
        ).aggregate(
            total_employee_payments_current_year=Coalesce(
                Sum('paymenttransaction__amount'),
                0,
                output_field=DecimalField()
            )
        )['total_employee_payments_current_year']

        total_purchases_current_year = Purchase.objects.filter(
            date__year=current_year,
            supplier__shop=shop
        ).aggregate(
            total_purchases_current_year=Coalesce(
                Sum(F('purchaseproduct__quantity_purchased') * F('purchaseproduct__product__buying_price')),
                0,
                output_field=DecimalField()
            )
        )['total_purchases_current_year']

        if shop.is_master:
            profit_current_year = (
                total_sales_current_year +
                total_transfers_current_year -
                total_purchases_current_year -
                total_costs_current_year -
                total_employee_payments_current_year
            )
        else:
            profit_current_year = (
                total_sales_current_year -
                total_transfers_current_year -
                total_costs_current_year -
                total_employee_payments_current_year
            )

        total_sales_previous_year = Sale.objects.filter(
            date__year=current_year - 1,
            client__shop=shop
        ).aggregate(
            total_sales_previous_year=Coalesce(
                Sum(F('sale_products__quantity_sold') * F('sale_products__product__saleing_price')),
                0,
                output_field=DecimalField()
            )
        )['total_sales_previous_year']

        total_transfers_previous_year = Transfer.objects.filter(
            date__year=current_year - 1,
            source_shop=shop
        ).aggregate(
            total_transfers_previous_year=Coalesce(
                Sum(F('transfer_items__quantity') * F('transfer_items__product__buying_price')),
                0,
                output_field=DecimalField()
            )
        )['total_transfers_previous_year']

        total_costs_previous_year = Coasts.objects.filter(
            date__year=current_year - 1,
            shop=shop
        ).aggregate(
            total_costs_previous_year=Sum('amount')
        )['total_costs_previous_year'] or 0

        total_employee_payments_previous_year = shop.employee_set.filter(
            paymenttransaction__transaction_date__year=current_year - 1
        ).aggregate(
            total_employee_payments_previous_year=Coalesce(
                Sum('paymenttransaction__amount'),
                0,
                output_field=DecimalField()
            )
        )['total_employee_payments_previous_year']

        total_purchases_previous_year = Purchase.objects.filter(
            date__year=current_year - 1,
            supplier__shop=shop
        ).aggregate(
            total_purchases_previous_year=Coalesce(
                Sum(F('purchaseproduct__quantity_purchased') * F('purchaseproduct__product__buying_price')),
                0,
                output_field=DecimalField()
            )
        )['total_purchases_previous_year']

        if shop.is_master:
            profit_previous_year = (
                total_sales_previous_year +
                total_transfers_previous_year -
                total_purchases_previous_year -
                total_costs_previous_year -
                total_employee_payments_previous_year
            )
        else:
            profit_previous_year = (
                total_sales_previous_year -
                total_transfers_previous_year -
                total_costs_previous_year -
                total_employee_payments_previous_year
            )

        evolution_rate_year_profit = (
            (profit_current_year - profit_previous_year) / profit_previous_year
        ) * 100 if profit_previous_year != 0 else 0

        response_data = {
            'profit_current_year': profit_current_year,
            'profit_previous_year': profit_previous_year,
            'evolution_rate_year_profit': evolution_rate_year_profit,
        }

        return Response(response_data)





