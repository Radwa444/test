import 'InvoiceItem.dart';

class ProductDiscountModel {
 final List<InvoiceItem> items;
 final double total;
 final int customerId ;
 ProductDiscountModel({required this.items,required this.total,this.customerId=0});


}