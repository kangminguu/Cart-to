from rest_framework import serializers
from .models import Product,UserInfo,Shopping,ShoppingList


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ('product_name', 'product_price', 'product_category')
    
class UserInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserInfo
        fields = ('user_pk','user_email', 'user_password', 'user_nickname')
    def create(self, validated_data):
        return UserInfo.objects.create(**validated_data)
class ShoppingListSerializer(serializers.ModelSerializer):
    class Meta:
        model = ShoppingList
        fields = {'user_pk', 'iden_num', 'price',  'sample_product', 'product_kinds'}

class ShoppingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Shopping
        fields = ('product_name', 'price', 'count')