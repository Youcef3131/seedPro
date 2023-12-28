# Django imports
from django.contrib import admin

# Your application's models
from .models import (
    Employee, Shop, Presence, PaymentTransaction,
    Category, Product, ProductInShop, Coasts,
    Client, Sale, SaleProduct, Supplier,
    Purchase, PurchaseProduct, PurchasePayment,
    SalePayment, Transfer, TransferItem, Composition
)

# List of all models
models_to_register = [
    Employee, Shop, Presence, PaymentTransaction,
    Category, Product, ProductInShop, Coasts,
    Client, Sale, SaleProduct, Supplier,
    Purchase, PurchaseProduct, PurchasePayment,
    SalePayment, Transfer, TransferItem, Composition
]

# Register each model
for model in models_to_register:
    admin.site.register(model)
