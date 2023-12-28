from django.urls import path
from . import views

urlpatterns = [
    # Authentication endpoints 
    path('login/', views.login),#works
    path('signup/', views.signup),#works
    path('logout/', views.logout),#works
    path('get-shop/<str:username>/', views.get_shop_by_username, name='get_shop_by_username'),#works
    # Shop-related endpoints
    path('add_shop/', views.AddShopView.as_view(), name='add_shop'),#works post
    path('shops/', views.ListShopsView.as_view(), name='list_shops'), #display shops #works get

    # Employee-related endpoints
    path('employees/<int:pk>/', views.RetrieveUpdateEmployeeView.as_view(), name='retrieve_update_employee'), ## get put employee works
    path('employees/', views.ListEmployeesView.as_view(), name='list_employees'), #display emplyees works

    # Payment Transaction endpoints
    path('paymenttransactions/add/', views.PaymentTransactionCreateView.as_view(), name='add_payment_transaction'), #works
    path('paymenttransactions/<int:pk>/', views.PaymentTransactionDeleteView.as_view(), name='delete-payment-transaction'), #delete
    path('paymenttransactions/employee/<int:employee_id>/', views.EmployeePaymentTransactionsView.as_view(), name='employee_payment_transactions'), #list payment for emplyee works

    # Presence endpoints
    path('presence/add/', views.AddPresenceView.as_view(), name='add_presence'), #works
    path('employee-presence/<int:employee_id>/<int:month>/', views.EmployeePresenceInMonthView.as_view(), name='employee_presence_in_month'), #works
  # Employee Details endpoints

# URL pattern for getting employee details without specifying a date
# Possible values for <str:method>: 
#   - 'remaining-salary'
#   - 'total-received'
#   - 'absences'
#   - 'total-paid'
#   - 'remaining-salary-whole-work'
# Example: /employees/1/remaining-salary/
path('employees/<int:employee_id>/<str:method>/', views.EmployeeDetailsView.as_view(), name='employee_details'),

# URL pattern for getting employee details with date information
# Possible values for <str:method>: 
#   - 'remaining-salary'
#   - 'total-received'
#   - 'absences'
#   - 'total-paid'
#   - 'remaining-salary-whole-work'
# Possible values for <int:month> and <int:year>: Any valid month and year values
# Example: /employees/1/remaining-salary/1/2023/
path('employees/<int:employee_id>/<str:method>/<int:month>/<int:year>/', views.EmployeeDetailsView.as_view(), name='employee_details_with_date'),

    # Category-related endpoints
    path('categories/', views.ListCreateCategoryView.as_view(), name='list_create_category'), #add cat list categoriess works
    path('categories/<int:pk>/', views.RetrieveUpdateCategoryView.as_view(), name='retrieve_update_category'), # get one + update works
    path('categories/<int:category_id>/products/', views.ListProductsInCategoryView.as_view(), name='list_products_in_category'),

    # Product endpoints
    # List and create products
    path('products/', views.ProductListView.as_view(), name='product-list'),
    path('product-in-shop/', views.ProductInShopListCreateView.as_view(), name='product-in-shop-list-create'),#not tested
    # Retrieve, update  specific product
    path('products/<int:pk>/', views.ProductDetailView.as_view(), name='product-detail'),

    # Shop Product endpoints
    path('shop/<int:shop_id>/products/', views.ShopProductsView.as_view(), name='shop_products'), # list product in shop
    path('shop/<int:shop_id>/products/<int:product_id>/', views.ShopProductDetailView.as_view(), name='shop_product_detail'), # one profuct in shop

    # Client 
    path('clients/', views.ClientListView.as_view(), name='client-list'), #list + add
    path('clients/<int:pk>/', views.ClientDetailView.as_view(), name='client-detail'), #get + update
    path('<int:shop_id>/clients/', views.ShopClientsView.as_view(), name='shop-clients'), #works
    #suppliers
    path('suppliers/', views.SupplierListView.as_view(), name='supplier-list'), #list + add
    path('suppliers/<int:pk>/', views.SupplierDetailView.as_view(), name='supplier-detail'), #get + update
      path('<int:shop_id>/suppliers/', views.ShopSuppliersView.as_view(), name='shop-suppliers'),#works
    #coasts
    path('coasts/', views.CoastsListView.as_view(), name='coasts-list'),
    path('coasts/<int:pk>/', views.CoastsDetailView.as_view(), name='coasts-detail'),  
    path('<int:shop_id>/coasts/', views.ShopCoastsView.as_view(), name='shop-coasts'),#works
    #needs total

    path('sale/', views.SaleListCreateView.as_view(), name='sale-list-create'),
    path('sale/<int:pk>/', views.SaleRetrieveUpdateDestroyView.as_view(), name='sale-retrieve-update-destroy'),#works
    
    path('saleproduct/', views.SaleProductListCreateView.as_view(), name='saleproduct-list-create'), #works
    path('saleproduct/<int:pk>/', views.SaleProductRetrieveUpdateDestroyView.as_view(), name='saleproduct-retrieve-update-destroy'),#works

    path('sales/shop/<int:shop_id>/', views.SaleListByShopView.as_view(), name='sale-list-by-shop'), #works
    path('sales/client/<int:client_id>/', views.SaleListByClientView.as_view(), name='sale-list-by-client'),#works
    path('saleproducts/sale/<int:sale_id>/', views.SaleProductListBySaleView.as_view(), name='saleproduct-list-by-sale'),


    path('salepayments/', views.SalePaymentListCreateView.as_view(), name='salepayment-list-create'),#works list add 
    path('salepayments/<int:pk>/', views.SalePaymentRetrieveDestroyView.as_view(), name='salepayment-retrieve-update-destroy'), #works delete

    path('calculate_sale_total/', views.SaleTotalView.as_view(), name='calculate_sale_total'), #works post method sale

    #purshase

    path('purchase/', views.PurchaseListCreateView.as_view(), name='purchase-list-create'),
    path('purchase/<int:pk>/', views.PurchaseRetrieveUpdateDestroyView.as_view(), name='purchase-retrieve-update-destroy'),
    
    path('purchaseproduct/', views.PurchaseProductListCreateView.as_view(), name='purchaseproduct-list-create'),
    path('purchaseproduct/<int:pk>/', views.PurchaseProductRetrieveUpdateDestroyView.as_view(), name='purchaseproduct-retrieve-update-destroy'),
    
    path('purchases/shop/<int:shop_id>/', views.PurchaseListByShopView.as_view(), name='purchase-list-by-shop'),
    path('purchases/supplier/<int:supplier_id>/', views.PurchaseListBySupplierView.as_view(), name='purchase-list-by-supplier'),
    path('purchaseproducts/purchase/<int:purchase_id>/', views.PurchaseProductListByPurchaseView.as_view(), name='purchaseproduct-list-by-purchase'),

    path('purchasepayments/', views.PurchasePaymentListCreateView.as_view(), name='purchasepayment-list-create'),
    path('purchasepayments/<int:pk>/', views.PurchasePaymentRetrieveDestroyView.as_view(), name='purchasepayment-retrieve-destroy'),
    path('calculate_purchase_total/', views.PurchaseTotalView.as_view(), name='calculate_purchase_total'),
    
    path('transfers/', views.TransferListCreateView.as_view(), name='transfer-list-create'), #works post + list
    path('transfers/<int:pk>/', views.TransferRetrieveUpdateDestroyView.as_view(), name='transfer-retrieve-update-destroy'),#works delete +put + get
    
    path('transfersitems/<int:transfer_id>/', views.TransferItemListCreateView.as_view(), name='transfer-item-list-create'), #works list+ post
    path('transfersitemsone/<int:pk>/', views.TransferItemRetrieveUpdateDestroyView.as_view(), name='transfer-item-retrieve-update-destroy'),#works get + delte + put

    path('transferstotal/<int:pk>/', views.CalculateTransferTotalView.as_view(), name='calculate-transfer-total'), #works

    path('compositions/', views.CompositionListCreateView.as_view(), name='composition-list-create'),#works
    path('compositions/<int:pk>/', views.CompositionRetrieveUpdateDestroyView.as_view(), name='composition-retrieve-update-destroy'), #works
    
]

