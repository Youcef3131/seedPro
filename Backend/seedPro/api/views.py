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


class ProductInShopListCreateView(generics.ListCreateAPIView):
    queryset = ProductInShop.objects.all()
    serializer_class = ProductInShopSerializer

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
