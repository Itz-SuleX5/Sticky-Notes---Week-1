from rest_framework import serializers
from .models import Note

class NoteSerializer(serializers.ModelSerializer):
    color = serializers.IntegerField(read_only=True)

    class Meta:
        model = Note
        fields = ['id', 'title', 'description', 'deadline', 'completed', 'color', 'position', 'rotation', 'created_at', 'updated_at']
        read_only_fields = ['id', 'color', 'created_at', 'updated_at']

    def to_representation(self, instance):
        data = super().to_representation(instance)
        if not data.get('position'):
            data['position'] = {'dx': 0.0, 'dy': 0.0}
        return data

    def validate_position(self, value):
        if not isinstance(value, dict) or 'dx' not in value or 'dy' not in value:
            return {'dx': 0.0, 'dy': 0.0}
        return {'dx': float(value['dx']), 'dy': float(value['dy'])}

    def validate_rotation(self, value):
        if not isinstance(value, (int, float)):
            return 0.0
        return float(value) 