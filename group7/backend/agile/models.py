from django.db import models

class Users(models.Model):
    id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=30)


class UserFavourites(models.Model):
    id = models.AutoField(primary_key=True)
    userid = models.ForeignKey(Users, on_delete=models.CASCADE)
    

