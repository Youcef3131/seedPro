# Generated by Django 5.0 on 2023-12-28 12:22

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0017_alter_transferitem_product'),
    ]

    operations = [
        migrations.RenameField(
            model_name='composition',
            old_name='quantity_used',
            new_name='quantity_composed',
        ),
        migrations.AlterField(
            model_name='transferitem',
            name='transfer',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='transfer_items', to='api.transfer'),
        ),
    ]
