import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nft_market/main.dart';

void main() {
  testWidgets('marketplace loads and filters auctions by category', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Live auctions'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);

    await tester.tap(find.text('Art'));
    await tester.pumpAndSettle();
    expect(find.text('Power of the Night'), findsOneWidget);
    expect(find.text('Digital Dreams'), findsNothing);
  });

  testWidgets('favorite actions show favorited auctions in favorites view', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.favorite).last);
    await tester.pump();
    expect(find.text('Your favorites'), findsOneWidget);
    expect(find.text('Power of the Night'), findsOneWidget);
  });
}
