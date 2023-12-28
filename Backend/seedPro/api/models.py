from django.db import models
from django.utils import timezone
class Shop(models.Model):
    name = models.CharField(max_length=50)
    address = models.CharField(max_length=50)
    is_master = models.BooleanField(default=False)

class Employee(models.Model):
    
    work_days_in_month = 26
    name = models.CharField(max_length=50)
    family_name = models.CharField(max_length=50)
    date_start = models.DateTimeField(default=timezone.now)
    email = models.EmailField()
    username = models.CharField(max_length=50, unique=True)
    password = models.CharField(max_length=100)
    monthly_salary = models.DecimalField(max_digits=10, decimal_places=2)
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE, default=1)



    def remaining_salary_at_end_of_month(self, month, year):
        total_received = self.total_received_amount_in_month(month, year)
        absences = self.number_of_absences_in_month(month, year)
        remaining_salary = self.monthly_salary - total_received - (absences * self.monthly_salary / self.work_days_in_month)
        return max(remaining_salary, 0)


    def total_received_amount_in_month(self, month, year):
        transactions_in_month = self.paymenttransaction_set.filter(
            employee=self,
            transaction_date__month=month,
            transaction_date__year=year
        )
        total_amount = transactions_in_month.aggregate(models.Sum('amount'))['amount__sum']
        return total_amount or 0

    def number_of_absences_in_month(self, month, year):
        presence_in_month = self.presence_set.filter(
            employee=self,
            presence_date__month=month,
            presence_date__year=year
        ).count()
        return self.work_days_in_month - presence_in_month

    def total_paid_amount(self):
        total_amount = self.paymenttransaction_set.aggregate(models.Sum('amount'))['amount__sum']
        return total_amount or 0

    def remaining_salary_for_whole_work(self):
        total_received = self.total_paid_amount()
        presence = self.presence_set.count()
        remaining_salary = self.monthly_salary * (presence / self.work_days_in_month) - total_received
        return max(remaining_salary, 0)

class Presence(models.Model):
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE)
    presence_date = models.DateField(default=timezone.now)

class PaymentTransaction(models.Model):
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    transaction_date = models.DateTimeField(default=timezone.now)


class Category(models.Model):
    name = models.CharField(max_length=50)
    description = models.CharField(max_length=100)

class Product(models.Model):
    reference = models.CharField(max_length=50)
    description = models.CharField(max_length=100)
    buying_price = models.DecimalField(max_digits=15, decimal_places=2)     
    saleing_price = models.DecimalField(max_digits=15, decimal_places=2)
    category = models.ForeignKey(Category, on_delete=models.CASCADE)


class ProductInShop(models.Model):
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.IntegerField(default=0)

    class Meta:
        unique_together = ['shop', 'product']

class Coasts(models.Model):
    date = models.DateField(default=timezone.now)
    description = models.CharField(max_length=100)
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE)

class Client(models.Model):
    name = models.CharField(max_length=50)
    family_name = models.CharField(max_length=50)
    phone = models.CharField(max_length=15)  
    address = models.CharField(max_length=50)
    email = models.EmailField()
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE)

class Sale(models.Model):
    date = models.DateTimeField(default=timezone.now)
    client = models.ForeignKey(Client, on_delete=models.CASCADE)    
    amountPaid = models.DecimalField(max_digits=15, decimal_places=2, default=0.0)

class SaleProduct(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity_sold = models.PositiveIntegerField(default=1)
    sale = models.ForeignKey(Sale, on_delete=models.CASCADE, related_name='sale_products')


class SalePayment(models.Model):
    sale = models.ForeignKey(Sale, on_delete=models.CASCADE)  
    date = models.DateTimeField(default=timezone.now)
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    
    


class Supplier(models.Model):
    name = models.CharField(max_length=50)
    family_name = models.CharField(max_length=50)
    phone = models.CharField(max_length=15)  
    address = models.CharField(max_length=50)
    email = models.EmailField()
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE)

class Purchase(models.Model):
    date = models.DateTimeField(default=timezone.now)
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE)
    amountPaidToSupplier = models.DecimalField(max_digits=15, decimal_places=2, default=0.0)

  

class PurchaseProduct(models.Model):
    purchase = models.ForeignKey(Purchase, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity_purchased = models.PositiveIntegerField(default=1)

class PurchasePayment(models.Model):
    purchase = models.ForeignKey(Purchase, on_delete=models.CASCADE)
    date = models.DateTimeField(default=timezone.now)
    amount = models.DecimalField(max_digits=15, decimal_places=2)


class Transfer(models.Model):
    source_shop = models.ForeignKey(Shop, related_name='transfers_made', on_delete=models.CASCADE)
    dest_shop = models.ForeignKey(Shop, related_name='transfers_received', on_delete=models.CASCADE)
    date = models.DateTimeField(default=timezone.now)

class TransferItem(models.Model):
    transfer = models.ForeignKey(Transfer, on_delete=models.CASCADE, related_name='transfer_items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)

class Composition(models.Model):
    shop = models.ForeignKey('Shop', on_delete=models.CASCADE)
    input_products = models.ManyToManyField('Product', related_name='compositions_used')
    output_product = models.ForeignKey('Product', related_name='compositions_created', on_delete=models.CASCADE)
    quantity_composed = models.PositiveIntegerField(default=1)