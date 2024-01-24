# serializers.py
from django.contrib.auth.models import User
from rest_framework.serializers import ModelSerializer
from rest_framework.authtoken.models import Token
from .models import *
from rest_framework import serializers, generics
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']

    def save(self, **kwargs):
        new_user = User.objects.create_user(
            username=self.validated_data['username'],
            email=self.validated_data['email'],
        )
        new_user.set_password(self.validated_data['password'])
        new_user.save()
        new_token = Token.objects.create(user=new_user)
        return new_user


class EmployeeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee
        fields = '__all__'


# Example ShopSerializer
class ShopSerializer(serializers.ModelSerializer):
    class Meta:
        model = Shop
        fields = '__all__'


class PaymentTransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = PaymentTransaction
        fields = '__all__'



class PresenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Presence
        fields = '__all__'
        


class EmployeeDetailsView(APIView):
    def get_employee(self, employee_id):
        try:
            return Employee.objects.get(pk=employee_id)
        except Employee.DoesNotExist:
            raise Http404("Employee does not exist")

    def get_remaining_salary_at_end_of_month(self, employee, month, year):
        remaining_salary = employee.remaining_salary_at_end_of_month(month, year)
        return Response({"remaining_salary": remaining_salary}, status=status.HTTP_200_OK)

    def get_total_received_amount_in_month(self, employee, month, year):
        total_received_amount = employee.total_received_amount_in_month(month, year)
        return Response({"total_received_amount": total_received_amount}, status=status.HTTP_200_OK)

    def get_number_of_absences_in_month(self, employee, month, year):
        absences = employee.number_of_absences_in_month(month, year)
        return Response({"absences": absences}, status=status.HTTP_200_OK)

    def get_total_paid_amount(self, employee_id):
        employee = self.get_employee(employee_id)
        total_paid_amount = employee.total_paid_amount()
        return Response({"total_paid_amount": total_paid_amount}, status=status.HTTP_200_OK)

    def get_remaining_salary_for_whole_work(self, employee_id):
        employee = self.get_employee(employee_id)
        remaining_salary = employee.remaining_salary_for_whole_work()
        return Response({"remaining_salary": remaining_salary}, status=status.HTTP_200_OK)

    def get(self, request, employee_id, method, month=None, year=None):
        employee = self.get_employee(employee_id)

        if method == 'remaining-salary':
            return self.get_remaining_salary_at_end_of_month(employee, month, year)
        elif method == 'total-received':
            return self.get_total_received_amount_in_month(employee, month, year)
        elif method == 'absences':
            return self.get_number_of_absences_in_month(employee, month, year)
        elif method == 'total-paid':
            return self.get_total_paid_amount(employee_id)
        elif method == 'remaining-salary-whole-work':
            return self.get_remaining_salary_for_whole_work(employee_id)
        else:
            return Response({"error": "Invalid method"}, status=status.HTTP_400_BAD_REQUEST)



class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'

class ProductInShopSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductInShop
        fields = '__all__'

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class ListCreateCategoryView(generics.ListCreateAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class RetrieveUpdateCategoryView(generics.RetrieveUpdateAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer


class ClientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Client
        fields = '__all__'

class SupplierSerializer(serializers.ModelSerializer):
    class Meta:
        model = Supplier
        fields = '__all__'

class CoastsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coasts
        fields = '__all__'


#sale

from django.db.models  import *

class SaleProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = SaleProduct
        fields = '__all__'


class SaleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sale
        fields = ['id','date', 'client', 'amountPaid']
       
from decimal import Decimal

class SaleInfoSerializer(serializers.ModelSerializer):
    client_name = serializers.CharField(source='client.family_name', read_only=True)
    client_first_name = serializers.CharField(source='client.name', read_only=True)
    total = serializers.DecimalField(max_digits=15, decimal_places=2, read_only=True)
    amount_not_paid = serializers.DecimalField(max_digits=15, decimal_places=2, read_only=True)

    class Meta:
        model = Sale
        fields = ['id', 'date', 'client', 'client_name', 'client_first_name', 'amountPaid', 'total', 'amount_not_paid']
        

    def to_representation(self, instance):
        data = super().to_representation(instance)

        # Calculate total and amount_not_paid
        total = SaleProduct.objects.filter(sale=instance).aggregate(
            total_amount=Sum(F('quantity_sold') * F('product__saleing_price')))['total_amount']

        data['total'] = total or Decimal('0.00')  # Convert float to Decimal here
        data['amount_not_paid'] = data['total'] - Decimal(data['amountPaid'])  # Convert float to Decimal here
        return data


class PurchaseInfoSerializer(serializers.ModelSerializer):
    supplier_name = serializers.CharField(source='supplier.name', read_only=True)
    supplier_family_name = serializers.CharField(source='supplier.family_name', read_only=True)
    total = serializers.DecimalField(max_digits=15, decimal_places=2, read_only=True)
    amount_not_paid = serializers.DecimalField(max_digits=15, decimal_places=2, read_only=True)

    class Meta:
        model = Purchase
        fields = ['id', 'date', 'supplier', 'supplier_name', 'supplier_family_name', 'amountPaidToSupplier', 'total', 'amount_not_paid']

    def to_representation(self, instance):
        data = super().to_representation(instance)

        # Calculate total and amount_not_paid
        total = PurchaseProduct.objects.filter(purchase=instance).aggregate(
            total_amount=Sum(F('quantity_purchased') * F('product__buying_price')))['total_amount']

        data['total'] = total or Decimal('0.00')  # Convert float to Decimal here
        data['amount_not_paid'] = data['total'] - Decimal(data['amountPaidToSupplier'])  # Convert float to Decimal here
        return data





class SaleProductDetailSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source='product.description', read_only=True)
    product_price = serializers.DecimalField(
        source='product.saleing_price',
        max_digits=15,  
        decimal_places=2,  
        read_only=True
    )

    class Meta:
        model = SaleProduct
        fields = ['product', 'product_name', 'quantity_sold', 'product_price', 'subtotal']

        
class SalePaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = SalePayment
        fields = '__all__'

from rest_framework import serializers

class SaleTotalSerializer(serializers.Serializer):
    total = serializers.DecimalField(max_digits=15, decimal_places=2)

    
################################################################


#purshase

class PurchaseProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = PurchaseProduct
        fields = '__all__'

class PurchaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Purchase
        fields = ['id', 'date', 'supplier', 'amountPaidToSupplier']

class PurchaseProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = PurchaseProduct
        fields = '__all__'

class PurchasePaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = PurchasePayment
        fields = '__all__'

class PurchaseInfoSerializer(serializers.ModelSerializer):
    supplier_name = serializers.CharField(source='supplier.family_name', read_only=True)
    supplier_first_name = serializers.CharField(source='supplier.name', read_only=True)
    total = serializers.DecimalField(max_digits=15, decimal_places=2, read_only=True)
    amount_not_paid = serializers.DecimalField(max_digits=15, decimal_places=2, read_only=True)

    class Meta:
        model = Purchase
        fields = ['id', 'date', 'supplier', 'supplier_name', 'supplier_first_name', 'amountPaidToSupplier', 'total', 'amount_not_paid']

    def to_representation(self, instance):
        data = super().to_representation(instance)

        # Calculate total and amount_not_paid
        total = PurchaseProduct.objects.filter(purchase=instance).aggregate(
            total_amount=Sum(F('quantity_purchased') * F('product__buying_price')))['total_amount']

        data['total'] = total or Decimal('0.00')  # Convert float to Decimal here
        data['amount_not_paid'] = data['total'] - Decimal(data['amountPaidToSupplier'])  # Convert float to Decimal here
        return data

class PurchaseProductDetailSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source='product.description', read_only=True)
    product_price = serializers.DecimalField(
        source='product.buying_price',
        max_digits=15,
        decimal_places=2,
        read_only=True
    )

    class Meta:
        model = PurchaseProduct
        fields = ['product', 'product_name', 'quantity_purchased', 'product_price', 'subtotal']
        
class TransferItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = TransferItem
        fields = '__all__'

class TransferSerializer(serializers.ModelSerializer):
    items = TransferItemSerializer(many=True, read_only=True)

    class Meta:
        model = Transfer
        fields = '__all__'



class CompositionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Composition
        fields = '__all__'


class IncompletePaymentsClientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Client
        fields = ['id', 'name', 'family_name', 'phone', 'address', 'email']





class ProductWithQuantitySerializer(serializers.ModelSerializer):
    product = ProductSerializer()

    class Meta:
        model = ProductInShop
        fields = '__all__'

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        product_data = representation.pop('product')
        for key, value in product_data.items():
            representation[key] = value
        return representation
