from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login),
    path('signup/', views.signup),
    path('logout/', views.logout),
    path('api/add_shop/', views.AddShopView.as_view(), name='add_shop'),
    path('api/shops/', views.ListShopsView.as_view(), name='list_shops'),
    path('api/employees/<int:pk>/', views.RetrieveUpdateEmployeeView.as_view(), name='retrieve_update_employee'),
    path('api/employees/', views.ListEmployeesView.as_view(), name='list_employees'),
    path('api/paymenttransactions/add/', views.AddPaymentTransactionView.as_view(), name='add_payment_transaction'),
    path('api/paymenttransactions/delete/<int:pk>/', views.DeletePaymentTransactionView.as_view(), name='delete_payment_transaction'),
    path('api/absences/add/', views.AddAbsenceView.as_view(), name='add_absence'),
    path('api/employees/<int:employee_id>/<str:method>/', views.EmployeeDetailsView.as_view(), name='employee_details'),
    path('api/employees/<int:employee_id>/<str:method>/<int:month>/<int:year>/', views.EmployeeDetailsView.as_view(), name='employee_details_with_date'),
    path('api/categories/', views.ListCreateCategoryView.as_view(), name='list_create_category'),
    path('api/categories/<int:pk>/', views.RetrieveUpdateCategoryView.as_view(), name='retrieve_update_category'),
    path('api/categories/<int:category_id>/products/', views.ListProductsInCategoryView.as_view(), name='list_products_in_category'),
]