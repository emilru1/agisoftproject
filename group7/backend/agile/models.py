from django.db import models

class Users(models.Model):
    id = models.AutoField(primary_key=True)
    username = models.CharField(unique=True, max_length=10, null=True) # Set to null temp


class UserFavourites(models.Model):
    id = models.AutoField(primary_key=True)
    userid = models.ForeignKey(Users, on_delete=models.CASCADE)
    lat = models.CharField(max_length=10)
    lon = models.CharField(max_length=10)

