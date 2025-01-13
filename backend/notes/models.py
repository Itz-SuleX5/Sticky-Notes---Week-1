import random
from django.db import models

class Note(models.Model):
    YELLOW_COLOR = 4294967040  # 0xFFFFFF00
    GREEN_COLOR = 4278255360   # 0xFF00FF00

    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=200)
    description = models.TextField()
    deadline = models.DateTimeField(null=True, blank=True)
    completed = models.BooleanField(default=False)
    position = models.JSONField()  
    rotation = models.FloatField(default=0.0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    @property
    def color(self):
        return self.GREEN_COLOR if self.completed else self.YELLOW_COLOR

    def save(self, *args, **kwargs):
        if not self.pk:  
            self.position = {
                'dx': random.uniform(20.0, 300.0),
                'dy': random.uniform(20.0, 300.0)
            }
            self.rotation = random.uniform(-0.1, 0.1)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.title

    class Meta:
        ordering = ['-created_at']
