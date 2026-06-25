test('Buy 2 Get 1 should execute twice', (){
final offer = Offer(
id: 1,
name: 'Buy 2 Get 1',
offerType: OfferType.buyXGetY,
)

final rules = [
// Condition
OfferAssembly(
state: 1,
productID: 1,
package: 1,
qty: 2,
),

// Gift
OfferAssembly(
state: 0,
productID: 2,
package: 1,
qty: 1,
name: 'Gift Product',
),
];

final items = [
InvoiceItem(
productId: 1,
packageId: 1,
qty: 4,
),
];

final engine = BonusProduct();

final isValid = engine.ValidateOffer(
offer,
rules,
items,
);

expect(isValid, true);

final result = engine.Apply(offer);

expect(result.offerId, 1);

expect(result.giftItems.length, 1);

expect(result.giftItems.first.productId, 2);

expect(result.giftItems.first.qty, 2);
});