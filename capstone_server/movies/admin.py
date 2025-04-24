from django.contrib import admin
from .models import Product, UserInfo, Shopping, ShoppingList




# Register your models here.
admin.site.register(Product)
admin.site.register(UserInfo)
admin.site.register(Shopping)
admin.site.register(ShoppingList)