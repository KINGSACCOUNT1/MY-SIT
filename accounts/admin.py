from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.utils.html import format_html
from decimal import Decimal
from .models import CustomUser, ActivityLog, Referral, BalanceAdjustment


@admin.register(CustomUser)
class CustomUserAdmin(UserAdmin):
    list_display = ['email', 'full_name', 'balance_display', 'account_type', 
                    'kyc_status', 'is_active', 'referral_code', 'date_joined']
    list_filter = ['is_active', 'is_staff', 'account_type', 'kyc_status', 'date_joined']
    search_fields = ['email', 'full_name', 'phone', 'referral_code']
    ordering = ['-date_joined']
    
    fieldsets = (
        ('Login Credentials', {
            'fields': ('email',)
        }),
        ('Personal Information', {
            'fields': ('full_name', 'phone', 'country', 'profile_image')
        }),
        ('💰 FINANCIAL MANAGEMENT (Use "Balance Adjustments" instead)', {
            'fields': ('balance', 'invested_amount', 'total_profit', 'total_withdrawn', 'referral_bonus'),
            'description': '<strong style="color: green;">⚠️ Use the "Balance Adjustment" section to add/deduct funds to keep transaction history correct!</strong>'
        }),
        ('Referral System', {
            'fields': ('referral_code', 'referred_by')
        }),
        ('Account Status', {
            'fields': ('account_type', 'kyc_status', 'email_verified'),
        }),
        ('Security Settings', {
            'fields': ('two_fa_enabled', 'two_fa_secret', 
                      'failed_login_attempts', 'locked_until'),
            'classes': ('collapse',)
        }),
        ('Permissions', {
            'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions'),
            'classes': ('collapse',)
        }),
        ('Important Dates', {
            'fields': ('date_joined', 'last_login', 'last_activity'),
            'classes': ('collapse',)
        }),
    )
    
    add_fieldsets = (
        (None, {
            'fields': ('email', 'full_name', 'password1', 'password2')
        }),
    )
    
    readonly_fields = ['date_joined', 'last_login', 'referral_code', 'two_fa_secret', 
                       'last_activity', 'failed_login_attempts', 'locked_until']
    
    def balance_display(self, obj):
        try:
            balance = float(obj.balance or 0)
            return f'${balance:,.2f}'
        except (ValueError, TypeError):
            return '$0.00'
    balance_display.short_description = 'Balance'
    
    def save_model(self, request, obj, form, change):
        # We disabled auto-notification here to prevent duplicate notifications
        # if using BalanceAdjustment model instead.
        super().save_model(request, obj, form, change)


@admin.register(ActivityLog)
class ActivityLogAdmin(admin.ModelAdmin):
    list_display = ['user', 'action', 'ip_address', 'created_at']
    list_filter = ['action', 'created_at']
    search_fields = ['user__email', 'description', 'ip_address']
    readonly_fields = ['user', 'action', 'description', 'ip_address', 'user_agent', 'created_at']
    list_select_related = ['user']
    
    def has_add_permission(self, request):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False


@admin.register(Referral)
class ReferralAdmin(admin.ModelAdmin):
    list_display = ['referrer', 'referred', 'bonus_amount', 'status', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['referrer__email', 'referred__email']
    readonly_fields = ['referrer', 'referred', 'created_at']
    list_select_related = ['referrer', 'referred']


@admin.register(BalanceAdjustment)
class BalanceAdjustmentAdmin(admin.ModelAdmin):
    list_display = ['user', 'amount', 'adjustment_type', 'admin', 'created_at']
    list_filter = ['adjustment_type', 'created_at']
    search_fields = ['user__email', 'admin__email']
    readonly_fields = ['admin', 'created_at']
    
    def save_model(self, request, obj, form, change):
        if not obj.pk:  # Creating new adjustment
            obj.admin = request.user
            
            # Apply to user
            from django.db import transaction
            with transaction.atomic():
                user = obj.user
                
                # Update user balance
                if obj.adjustment_type == 'add':
                    user.balance += obj.amount
                else:
                    user.balance -= obj.amount
                user.save()
                
                # Create notification
                from notifications.models import Notification
                Notification.objects.create(
                    user=user,
                    title=f'Balance {obj.adjustment_type.title()}',
                    message=f'Your balance was adjusted by ${obj.amount:,.2f}. Reason: {obj.reason}',
                    notification_type='info'
                )
        
        super().save_model(request, obj, form, change)
