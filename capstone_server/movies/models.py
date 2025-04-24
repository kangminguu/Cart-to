from django.db import models

class Product(models.Model):
    product_name = models.CharField(primary_key = True, max_length=30)
    product_price = models.IntegerField()
    product_category = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'product'
    def __str__(self):
        return self.product_name

class Shopping(models.Model):
    shopping_id = models.IntegerField(primary_key=True)
    user_pk = models.ForeignKey('UserInfo', models.DO_NOTHING, db_column='user_pk')
    price = models.IntegerField()
    product_name = models.ForeignKey(Product, models.DO_NOTHING, db_column='product_name')
    count = models.IntegerField()
    iden_num = models.ForeignKey('ShoppingList', models.DO_NOTHING, db_column='iden_num')

    class Meta:
        managed = False
        db_table = 'shopping'
    def __str__(self):
        return str(self.iden_num)


class ShoppingList(models.Model):
    user_pk = models.ForeignKey('UserInfo', models.DO_NOTHING, db_column='user_pk')
    iden_num = models.IntegerField(primary_key=True)
    price = models.IntegerField()
    buy_date = models.DateField()
    sample_product = models.ForeignKey(Product, models.DO_NOTHING, db_column='sample_product')
    product_kinds = models.IntegerField()
    product_count = models.IntegerField()
    class Meta:
        managed = False
        db_table = 'shopping_list'


class UserInfo(models.Model):
    user_pk = models.IntegerField(primary_key=True)
    user_email = models.CharField(unique=True, max_length=45, )
    user_password = models.CharField(max_length=15)
    user_nickname = models.CharField(unique=True, max_length=8)

    class Meta:
        managed = False
        db_table = 'user_info'
    def __str__(self):
        return str(self.user_pk)