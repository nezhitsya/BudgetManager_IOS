from .models import Account

class AccountSerializer(serializers.ModelSerializer) :
    class Meta :
        model = Account
        fields = ['name', 'category', 'description', 'wealth_type', 'balance']