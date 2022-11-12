# Generated by Django 4.0.2 on 2022-10-08 15:01

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('maanage', '0002_remove_address_empid_employee_address'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='employee',
            name='address',
        ),
        migrations.AddField(
            model_name='address',
            name='empid',
            field=models.ForeignKey(default='', on_delete=django.db.models.deletion.CASCADE, to='maanage.employee'),
        ),
    ]