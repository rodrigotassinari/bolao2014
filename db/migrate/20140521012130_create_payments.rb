class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :bet_id, null: false
      t.string :reference, null: false
      t.string :status, null: false, default: 'initiated'
      t.decimal :amount, null: false, precision: 14, scale: 2
      t.datetime :paid_at
      t.string :checkout_code
      t.string :checkout_url
      t.string :transaction_code
      t.decimal :gross_amount, precision: 14, scale: 2
      t.decimal :discount_amount, precision: 14, scale: 2
      t.decimal :fee_amount, precision: 14, scale: 2
      t.decimal :net_amount, precision: 14, scale: 2
      t.decimal :extra_amount, precision: 14, scale: 2
      t.integer :installments
      t.datetime :escrow_ends_at
      t.string :payer_name
      t.string :payer_email
      t.string :payer_phone

      t.timestamps
    end
    add_index :payments, :bet_id, unique: true
    add_index :payments, :reference, unique: true
    add_index :payments, :status
  end
end
