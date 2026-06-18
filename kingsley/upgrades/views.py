from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import AccountUpgrade

@login_required
def upgrade_plans(request):
    """Display available account upgrade tiers"""
    # Define tier data for display
    tiers = [
        {'name': 'Intermediate', 'amount': 500, 'benefits': AccountUpgrade.get_tier_benefits('intermediate')},
        {'name': 'Advanced', 'amount': 2000, 'benefits': AccountUpgrade.get_tier_benefits('advanced')},
        {'name': 'VIP', 'amount': 10000, 'benefits': AccountUpgrade.get_tier_benefits('vip')},
    ]
    return render(request, 'upgrades/upgrade_plans.html', {'tiers': tiers})
