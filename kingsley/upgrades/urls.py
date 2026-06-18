from django.urls import path
from . import views

app_name = 'upgrades'

urlpatterns = [
    path('', views.upgrade_plans, name='upgrade_plans'),
]
