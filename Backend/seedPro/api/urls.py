from django.urls import path
from . import views

urlpatterns = [
    # Authentication endpoints 
    path('login/', views.login),#works
    path('signup/', views.signup),#works
    path('logout/', views.logout),#works
    path('get-shop/<str:username>/', views.get_shop_by_username, name='get_shop_by_username'),#works
    path('get-employee/<str:username>/', views.RetrieveEmployeeView.as_view(), name='get_employee'),
    # Shop-related endpoints
    path('add_shop/', views.AddShopView.as_view(), name='add_shop'),#works post
    path('shops/', views.ListShopsView.as_view(), name='list_shops'), #display shops #works get
    path('shops/<int:pk>/', views.RetrieveShopView.as_view(), name='retrieve_shop'),


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
    
    path('products-in-shop/<int:shop_id>/', views.ProductInShopListView.as_view(), name='product-in-shop-list'), #list product withquntites

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
    
    path('all-sales-info/<int:shop_id>/', views.AllSalesInfoView.as_view(), name='all-sales-info'), # dislays list sales information
    
    path('saleproduct/', views.SaleProductListCreateView.as_view(), name='saleproduct-list-create'), #works
    path('saleproduct/<int:pk>/', views.SaleProductRetrieveUpdateDestroyView.as_view(), name='saleproduct-retrieve-update-destroy'),#works

    path('sales/shop/<int:shop_id>/', views.SaleListByShopView.as_view(), name='sale-list-by-shop'), #works
    path('sales/client/<int:client_id>/', views.SaleListByClientView.as_view(), name='sale-list-by-client'),#works
    path('saleproducts/sale/<int:sale_id>/', views.SaleProductListBySaleView.as_view(), name='saleproduct-list-by-sale'),
    path('sale-products/<int:sale_id>/', views.SaleProductDetailView.as_view(), name='sale-product-detail'),

    path('salepayments/', views.SalePaymentListCreateView.as_view(), name='salepayment-list-create'),#works list add 
    path('salepayments/<int:pk>/', views.SalePaymentRetrieveDestroyView.as_view(), name='salepayment-retrieve-update-destroy'), #works delete

    path('calculate_sale_total/', views.SaleTotalView.as_view(), name='calculate_sale_total'), #works post method sale

    #purshase

    path('purchase/', views.PurchaseListCreateView.as_view(), name='purchase-list-create'),
    path('purchase/<int:pk>/', views.PurchaseRetrieveUpdateDestroyView.as_view(), name='purchase-retrieve-update-destroy'),
    
    path('purchase-products/<int:purchase_id>/', views.PurchaseProductDetailView.as_view(), name='purchase-product-detail'),

    path('purchaseproduct/', views.PurchaseProductListCreateView.as_view(), name='purchaseproduct-list-create'),
    path('purchaseproduct/<int:pk>/', views.PurchaseProductRetrieveUpdateDestroyView.as_view(), name='purchaseproduct-retrieve-update-destroy'),
    
    path('purchases/shop/<int:shop_id>/', views.PurchaseListByShopView.as_view(), name='purchase-list-by-shop'),
    path('purchases/supplier/<int:supplier_id>/', views.PurchaseListBySupplierView.as_view(), name='purchase-list-by-supplier'),
    path('purchaseproducts/purchase/<int:purchase_id>/', views.PurchaseProductListByPurchaseView.as_view(), name='purchaseproduct-list-by-purchase'),
    path('all-purchases-info/<int:shop_id>/', views.AllPurchasesInfoView.as_view(), name='all-purchases-info'),
    path('purchasepayments/', views.PurchasePaymentListCreateView.as_view(), name='purchasepayment-list-create'),
    path('purchasepayments/<int:pk>/', views.PurchasePaymentRetrieveDestroyView.as_view(), name='purchasepayment-retrieve-destroy'),
    path('calculate_purchase_total/', views.PurchaseTotalView.as_view(), name='calculate_purchase_total'),
    #Unpaid
    path('clients-with-unpaid-sales/<int:shop_id>/', views.ClientsWithUnpaidSalesView.as_view(), name='clients_with_unpaid_sales'),
    path('suppliers-with-unpaid-purchases/<int:shop_id>/', views.SuppliersWithUnpaidPurchasesView.as_view(), name='suppliers-with-unpaid-purchases'),

    path('transfers/', views.TransferListCreateView.as_view(), name='transfer-list-create'), #works post + list
    path('transfers/<int:pk>/', views.TransferRetrieveUpdateDestroyView.as_view(), name='transfer-retrieve-update-destroy'),#works delete +put + get
    
    path('transfersitems/<int:transfer_id>/', views.TransferItemListCreateView.as_view(), name='transfer-item-list-create'), #works list+ post
    path('transfersitemsone/<int:pk>/', views.TransferItemRetrieveUpdateDestroyView.as_view(), name='transfer-item-retrieve-update-destroy'),#works get + delte + put

    path('transferstotal/<int:pk>/', views.CalculateTransferTotalView.as_view(), name='calculate-transfer-total'), #works

    path('compositions/', views.CompositionListCreateView.as_view(), name='composition-list-create'),#works
    path('compositions/<int:pk>/', views.CompositionRetrieveUpdateDestroyView.as_view(), name='composition-retrieve-update-destroy'), #works
    

    path('top-clients-per-year/<shop_id>/', views.TopClientsPerYearView.as_view(), name='top-clients-per-year'),
    path('top-clients-per-month/<shop_id>/', views.TopClientsPerMonthView.as_view(), name='top-clients-per-month'),


    path('top-suppliers-per-month/<shop_id>/', views.TopSuppliersPerMonthView.as_view(), name='top-suppliers-per-month'),
    path('top-suppliers-per-year/<shop_id>/', views.TopSuppliersPerYearView.as_view(), name='top-suppliers-per-year'),

    path('best-selling-products/<shop_id>/', views.BestSellingProductsView.as_view(), name='best-selling-products'), #works

    path('purchase-evolution-month/<int:shop_id>/', views.PurchaseEvolutionMonthView.as_view(), name='purchase-evolution-month'),
    path('purchase-evolution-year/<int:shop_id>/', views.PurchaseEvolutionYearView.as_view(), name='purchase-evolution-year'),
    path('sales-evolution-month/<int:shop_id>/', views.SalesEvolutionMonthView.as_view(), name='sales-evolution-month'),
    path('sales-evolution-year/<int:shop_id>/', views.SalesEvolutionYearView.as_view(), name='sales-evolution-year'),
    path('sales-last-5-days-per-shop/<int:shop_id>/', views.ShopSalesLast5DaysAPIView.as_view(), name='sales-last-5-days-per-shop'),
    path('profit-evolution-year/<int:shop_id>/', views.ProfitEvolutionYearView.as_view(), name='profit-evolution-year'),
    
]

