from django.contrib import admin
from django.utils.html import format_html
from django.utils import timezone
from .models import AccountUpgrade

@admin.register(AccountUpgrade)
class AccountUpgradeAdmin(admin.ModelAdmin):
    list_display = ['user', 'current_tier_display', 'requested_tier', 'amount', 'status_badge', 'created_at', 'actions_display']
    list_filter = ['status', 'requested_tier']
    search_fields = ['user__email']
    actions = ['approve_upgrades', 'reject_upgrades']
    
    fieldsets = (
        ('User & Request', {
            'fields': ('user', 'requested_tier', 'amount')
        }),
        ('✅ APPROVAL', {
            'fields': ('status', 'admin_note', 'processed_by', 'processed_at'),
            'description': '<strong style="color: green;">Change status to "Approved" to upgrade user account</strong>'
        }),
    )
    
    readonly_fields = ['user', 'created_at']
    
    def current_tier_display(self, obj):
        return obj.current_tier # Assuming the field exists
    current_tier_display.short_description = 'Current Tier'
    
    def status_badge(self, obj):
        colors = {
            'pending': 'orange',
            'approved': 'green',
            'rejected': 'red'
        }
        color = colors.get(obj.status, 'gray')
        return format_html(
            '<span style="background-color: {}; color: white; padding: 3px 8px; border-radius: 3px;">{}</span>',
            color, obj.get_status_display()
        )
    status_badge.short_description = 'Status'
    
    def actions_display(self, obj):
        if obj.status == 'pending':
            return format_html('<span style="color: orange;">⏳ Waiting for approval</span>')
        return '-'
    actions_display.short_description = 'Quick Action'
    
    def approve_upgrades(self, request, queryset):
        """Approve account upgrades and update user tier"""
        count = 0
        for upgrade in queryset.filter(status='pending'):
            user = upgrade.user
            # NOTE: Assuming CustomUser has an 'account_type' field
            user.account_type = upgrade.requested_tier
            user.save()
            
            upgrade.status = 'approved'
            upgrade.processed_by = request.user
            upgrade.processed_at = timezone.now()
            upgrade.save()
            count += 1
        
        self.message_user(request, f'{count} account upgrades approved!')
    approve_upgrades.short_description = '✅ Approve selected upgrades'
    
    def reject_upgrades(self, request, queryset):
        """Reject account upgrades"""
        count = 0
        for upgrade in queryset.filter(status='pending'):
            upgrade.status = 'rejected'
            upgrade.processed_by = request.user
            upgrade.processed_at = timezone.now()
            upgrade.admin_note = 'Rejected by admin'
            upgrade.save()
            count += 1
        
        self.message_user(request, f'{count} account upgrades rejected.')
    reject_upgrades.short_description = '❌ Reject selected upgrades'
    
    def save_model(self, request, obj, form, change):
        if change:
            old_status = AccountUpgrade.objects.get(pk=obj.pk).status
            if old_status != obj.status and obj.status == 'approved':
                user = obj.user
                user.account_type = obj.requested_tier
                user.save()
                
                obj.processed_by = request.user
                obj.processed_at = timezone.now()
        
        super().save_model(request, obj, form, change)
