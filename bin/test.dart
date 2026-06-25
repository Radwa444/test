import 'dart:math';

import 'model/Customer.dart';
import 'model/InvoiceItem.dart';
import 'model/Offer.dart';
import 'model/OfferAssembly.dart';
import 'offer/BonusProduct.dart';
import 'strategey/BuyXGetYStrategy.dart';


enum OfferType {
  buyXGetY('buyXGetY'),
  InvoiceDiscount('invoice'),
  customer('customer'),
  productDiscount('product_discount');

  final String value;
  const OfferType(this.value);
}






// ============================================
// 2. الـ Strategy نفسها (مع تعديل بسيط للأخطاء)
// ============================================

final _random = Random();

int randomInt({int min = 0, int max = 100}) =>
    min + _random.nextInt(max - min + 1);

double randomDouble({double min = 0, double max = 100}) =>
    min + _random.nextDouble() * (max - min);

// 3.1 إنشاء Offer وهمي من نوع BuyXGetY
Offer createFakeBuyXGetYOffer({int? id}) {
  return Offer(
    id: id ?? randomInt(min: 1, max: 100),
    name: 'Buy X Get Y ${randomInt(min: 1, max: 999)}',
    description: 'اشترِ منتج واحصل على آخر مجاناً',
    offerType: OfferType.buyXGetY.value,
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    remoteSync: 0,
  );
}

// 3.2 إنشاء قواعد العرض (OfferAssembly)
List<OfferAssembly> createFakeBuyXGetYRules({
  int? offerId,
  int buyProductId = 1,
  int buyPackageId = 1,
  double buyQty = 2,
  int giftProductId = 2,
  int giftPackageId = 1,
  double giftQty = 1,
}) {
  return [
    // قاعدة الشراء (state = 1)
    OfferAssembly(
      id: randomInt(min: 1, max: 1000),
      offerId: offerId ?? randomInt(min: 1, max: 100),
      customerID: null, // عرض عام
      productID: buyProductId,
      package: buyPackageId,
      state: 1, // 1 = شراء
      name: 'Buy Rule',
      startDate: DateTime.now().toIso8601String(),
      endDate: DateTime.now().add(Duration(days: 30)).toIso8601String(),
      value: 0,
      pecentage: 0,
      qty: buyQty,
      createAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
      remoteSync: 0,
      updateSync: 0,
    ),
    // قاعدة الهدية (state = 0)
    OfferAssembly(
      id: randomInt(min: 1, max: 1000),
      offerId: offerId ?? randomInt(min: 1, max: 100),
      customerID: null,
      productID: giftProductId,
      package: giftPackageId,
      state: 0, // 0 = هدية
      name: 'Gift Rule',
      startDate: DateTime.now().toIso8601String(),
      endDate: DateTime.now().add(Duration(days: 30)).toIso8601String(),
      value: 0,
      pecentage: 0,
      qty: giftQty,
      createAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
      remoteSync: 0,
      updateSync: 0,
    ),
  ];
}

// 3.3 إنشاء عناصر فاتورة وهمية
List<InvoiceItem> createFakeInvoiceItems({
  int? invoiceId,
  List<Map<String, dynamic>>? customItems,
}) {
  if (customItems != null) {
    return customItems.map((item) {
      return InvoiceItem(
        id: randomInt(min: 1, max: 1000),
        invoiceId: invoiceId ?? randomInt(min: 1, max: 100),
        productId: item['productId'] as int?,
        packageId: item['packageId'] as int?,
        productName: item['productName'] as String? ?? 'Product ${item['productId']}',
        qty: (item['qty'] as num?)?.toDouble() ?? 1.0,
        unitPrice: (item['unitPrice'] as num?)?.toDouble() ?? 10.0,
        lineTotal: ((item['qty'] as num?)?.toDouble() ?? 1.0) *
            ((item['unitPrice'] as num?)?.toDouble() ?? 10.0),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        remoteSync: 0,
        pricingId: randomInt(min: 1, max: 50),
      );
    }).toList();
  }

  // بيانات افتراضية
  return [
    InvoiceItem(
      id: randomInt(min: 1, max: 1000),
      invoiceId: invoiceId ?? randomInt(min: 1, max: 100),
      productId: 1,
      packageId: 1,
      productName: 'Product 1',
      qty: 4, // 4 قطع تكفي لـ 2 مرات (لأن الشرط 2)
      unitPrice: 10.0,
      lineTotal: 40.0,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      remoteSync: 0,
      pricingId: 1,
    ),
    InvoiceItem(
      id: randomInt(min: 1, max: 1000),
      invoiceId: invoiceId ?? randomInt(min: 1, max: 100),
      productId: 2,
      packageId: 1,
      productName: 'Product 2',
      qty: 0, // سيتم حساب الهدية
      unitPrice: 0,
      lineTotal: 0,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      remoteSync: 0,
      pricingId: 1,
    ),
  ];
}

// 3.4 Customer وهمي
Customer createFakeCustomer({int? id}) {
  return Customer(
    id ?? randomInt(min: 1, max: 100),
    'Customer ${randomInt(min: 1, max: 999)}',
  );
}

// ============================================
// 4. سيناريوهات اختبار مختلفة
// ============================================

// سيناريو 1: عرض Buy 2 Get 1 (أساسي)
void testScenario1_Basic() {
  print('\n========== سيناريو 1: Buy 2 Get 1 ==========');

  final offer = createFakeBuyXGetYOffer();
  final rules = createFakeBuyXGetYRules(
    offerId: offer.id,
    buyProductId: 1,
    buyPackageId: 1,
    buyQty: 2,
    giftProductId: 2,
    giftPackageId: 1,
    giftQty: 1,
  );

  final items = createFakeInvoiceItems(
    customItems: [
      {'productId': 1, 'packageId': 1, 'qty': 4, 'unitPrice': 10}, // 4 قطع = مرتين
    ],
  );

  // final customer = createFakeCustomer();
  // final strategy = BuyXGetYStrategy();
  final bonusProduct = BonusProduct();

  print('📦 العرض: ${offer.name}');
  print('📋 القواعد:');
  for (var rule in rules) {
    print('  - ${rule.state == 1 ? "شراء" : "هدية"}: منتج ${rule.productID} × ${rule.qty}');
  }
  print('🛒 عناصر الفاتورة:');
  for (var item in items) {
    print('  - ${item.productName}: ${item.qty} × ${item.unitPrice} = ${item.lineTotal}');
  }
  bonusProduct.validateCondition(rules, items);
  final result=bonusProduct.Apply(offer);

 // final result = strategy.apply(offer, rules, items, customer);

  print('\n🎁 النتيجة:');
  print('  - عدد الهدايا: ${result.giftItems.length}');
  for (var gift in result.giftItems) {
    print('  - 🎁 ${gift.productName}: ${gift.qty} قطعة مجاناً');
  }
}

// سيناريو 2: كميات غير كافية
void testScenario2_NotEnoughQty() {
  print('\n========== سيناريو 2: كميات غير كافية ==========');

  final offer = createFakeBuyXGetYOffer();
  final rules = createFakeBuyXGetYRules(
    buyProductId: 1,
    buyQty: 5, // يحتاج 5 قطع
    giftProductId: 2,
    giftQty: 2,
  );

  final items = createFakeInvoiceItems(
    customItems: [
      {'productId': 1, 'packageId': 1, 'qty': 3, 'unitPrice': 10}, // فقط 3 قطع
    ],
  );

  final strategy = BuyXGetYStrategy();
  final result = strategy.apply(offer, rules, items, null);

  print('📦 العرض: ${offer.name}');
  print('📋 القاعدة: اشترِ 5 واحصل على 2 مجاناً');
  print('🛒 المتوفر: 3 قطع فقط');
  print('\n🎁 النتيجة: ${result.giftItems.length} هدايا (لا يوجد)');
}

// سيناريو 3: عروض متعددة (عدة منتجات)
void testScenario3_MultipleProducts() {
  print('\n========== سيناريو 3: عروض متعددة ==========');

  final offer = createFakeBuyXGetYOffer(id: 999);

  // قواعد متعددة: شراء منتجين مختلفين والحصول على هدايا
  final rules = [
    // شراء منتج 1
    OfferAssembly(
      id: 1,
      offerId: offer.id!,
      productID: 1,
      package: 1,
      state: 1,
      qty: 2,
      name: 'Buy Product 1',
      startDate: DateTime.now().toIso8601String(),
      endDate: DateTime.now().add(Duration(days: 30)).toIso8601String(),
      value: 0,
      pecentage: 0,
      createAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
      remoteSync: 0,
      updateSync: 0,
      customerID: null,
    ),
    // شراء منتج 2
    OfferAssembly(
      id: 2,
      offerId: offer.id!,
      productID: 3,
      package: 1,
      state: 1,
      qty: 3,
      name: 'Buy Product 3',
      startDate: DateTime.now().toIso8601String(),
      endDate: DateTime.now().add(Duration(days: 30)).toIso8601String(),
      value: 0,
      pecentage: 0,
      createAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
      remoteSync: 0,
      updateSync: 0,
      customerID: null,
    ),
    // هدية منتج 2
    OfferAssembly(
      id: 3,
      offerId: offer.id!,
      productID: 2,
      package: 1,
      state: 0,
      qty: 1,
      name: 'Gift Product 2',
      startDate: DateTime.now().toIso8601String(),
      endDate: DateTime.now().add(Duration(days: 30)).toIso8601String(),
      value: 0,
      pecentage: 0,
      createAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
      remoteSync: 0,
      updateSync: 0,
      customerID: null,
    ),
    // هدية منتج 4
    OfferAssembly(
      id: 4,
      offerId: offer.id!,
      productID: 4,
      package: 1,
      state: 0,
      qty: 2,
      name: 'Gift Product 4',
      startDate: DateTime.now().toIso8601String(),
      endDate: DateTime.now().add(Duration(days: 30)).toIso8601String(),
      value: 0,
      pecentage: 0,
      createAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
      remoteSync: 0,
      updateSync: 0,
      customerID: null,
    ),
  ];

  final items = createFakeInvoiceItems(
    customItems: [
      {'productId': 1, 'packageId': 1, 'qty': 4, 'unitPrice': 10}, // منتج 1: 4 قطع
      {'productId': 3, 'packageId': 1, 'qty': 6, 'unitPrice': 15}, // منتج 3: 6 قطع
    ],
  );

  final strategy = BuyXGetYStrategy();
  final result = strategy.apply(offer, rules, items, null);

  print('📦 العرض: ${offer.name}');
  print('📋 القواعد:');
  for (var rule in rules) {
    print('  - ${rule.state == 1 ? "🛒 شراء" : "🎁 هدية"}: منتج ${rule.productID} × ${rule.qty}');
  }
  print('\n🛒 عناصر الفاتورة:');
  for (var item in items) {
    print('  - ${item.productName}: ${item.qty} قطعة');
  }
  print('\n🎁 الهدايا المستلمة:');
  for (var gift in result.giftItems) {
    print('  - 🎁 ${gift.productName}: ${gift.qty} قطعة مجاناً');
  }
}

// سيناريو 4: مع عميل محدد (عرض خاص)
void testScenario4_CustomerSpecific() {
  print('\n========== سيناريو 4: عرض خاص لعميل ==========');

  final offer = createFakeBuyXGetYOffer();
  final customer = createFakeCustomer(id: 50);

  // عرض خاص للعميل 50
  final rules = createFakeBuyXGetYRules(
    offerId: offer.id,
    buyProductId: 1,
    buyQty: 1, // اشترِ 1 فقط
    giftProductId: 2,
    giftQty: 1,
  );

  // نعدل القاعدة لتكون خاصة بالعميل
  rules[0].customerID = 50;
  rules[1].customerID = 50;

  final items = createFakeInvoiceItems(
    customItems: [
      {'productId': 1, 'packageId': 1, 'qty': 3, 'unitPrice': 10},
    ],
  );

  final strategy = BuyXGetYStrategy();
  final result = strategy.apply(offer, rules, items, customer);

  print('👤 العميل: ${customer.name} (ID: ${customer.id})');
  print('📦 العرض: ${offer.name} (خاص بالعميل)');
  print('🛒 اشترى: 3 قطع من منتج 1');
  print('🎁 حصل على: ${result.giftItems.length} هدية');
  for (var gift in result.giftItems) {
    print('  - 🎁 ${gift.productName}: ${gift.qty} قطعة مجاناً');
  }
}

// ============================================
// 5. main() - تشغيل جميع السيناريوهات
// ============================================
void main() {
  print('🧪 اختبار BuyXGetYStrategy');
  print('=' * 50);

  //testScenario1_Basic();
  // testScenario2_NotEnoughQty();
  // testScenario3_MultipleProducts();
  // testScenario4_CustomerSpecific();
  testScenario1_Basic();
}


