# Generated by Django 5.0 on 2023-12-27 14:09

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0006_auto_20231227_0115'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='productinshop',
            unique_together={('shop', 'product')},
        ),
    ]