from django.db import models
from django.conf import settings
from django.utils import timezone

class AccountUpgrade(models.Model):
    """Account tier upgrade requests"""
    
    TIER_CHOICES = [
        ('intermediate', 'Intermediate - $500'),
        ('advanced', 'Advanced - $2,000'),
        ('vip', 'VIP - $10,000'),
    ]
    
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('paid', 'Paid'),
        ('confirmed', 'Confirmed'),
        ('rejected', 'Rejected'),
    ]
    
    TIER_AMOUNTS = {
        'intermediate': 500,
        'advanced': 2000,
        'vip': 10000,
    }
    
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='account_upgrades')
    current_tier = models.CharField(max_length=20)
    requested_tier = models.CharField(max_length=20, choices=TIER_CHOICES)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    payment_method = models.CharField(max_length=50, default='balance')
    
    # Status
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    processed_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='processed_upgrades'
    )
    processed_at = models.DateTimeField(null=True, blank=True)
    admin_note = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Account Upgrade'
        verbose_name_plural = 'Account Upgrades'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.user.email} - {self.requested_tier} - {self.status}"
    
    @staticmethod
    def get_tier_benefits(tier):
        """Get benefits for each tier"""
        benefits = {
            'intermediate': {
                'roi_boost': '5%',
                'support': 'Priority Support',
                'insights': 'Weekly Market Insights',
            },
            'advanced': {
                'roi_boost': '10%',
                'support': '24/7 Support',
                'insights': 'Daily Market Insights',
                'fees': 'Lower Transaction Fees',
            },
            'vip': {
                'roi_boost': '15%',
                'support': 'Personal Account Manager',
                'insights': 'Exclusive Investment Plans',
                'fees': 'Zero Transaction Fees',
                'events': 'VIP Events Access',
            },
        }
        return benefits.get(tier, {})
