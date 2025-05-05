class AddPaymentMethodToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :payment_method, :string
  end
end
