# Generated by Django 5.1.4 on 2025-01-12 21:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('notes', '0003_alter_note_id'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='note',
            name='color',
        ),
        migrations.AddField(
            model_name='note',
            name='completed',
            field=models.BooleanField(default=False),
        ),
    ]
