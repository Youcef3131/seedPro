# permissions.py
from rest_framework import permissions

class IsAdminOrReadOnly(permissions.BasePermission):
    def has_permission(self, request, view):
        # Allow any authenticated user to view details
        return request.user.is_authenticated

    def has_object_permission(self, request, view, obj):
        # Allow administrators to view and change data
        return request.user.is_staff

