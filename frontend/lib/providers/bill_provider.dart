import 'package:flutter/material.dart';
import '../features/billing/models/bill_model.dart';
import 'customer_provider.dart';

class BillProvider extends ChangeNotifier {
  final List<BillModel> _bills = [];

  List<BillModel> get bills => _bills;

  /// 🆕 CREATE BILL
  void addBill(BillModel bill, CustomerProvider customerProvider) {
    _bills.add(bill);

    /// if unpaid → add ledger entry
    if (!bill.isPaid) {
      customerProvider.addTransaction(bill.customerName, {
        'amount': bill.grandTotal,
        'note': 'Bill ${bill.billNo}',
        'date': DateTime.now(),
        'type': 'GIVEN',
      });
    }

    notifyListeners();
  }

  /// ✏️ UPDATE BILL (EDIT)
  void updateBill(BillModel updatedBill, CustomerProvider customerProvider) {
    final index = _bills.indexWhere((b) => b.id == updatedBill.id);
    if (index == -1) return;

    final oldBill = _bills[index];

    /// remove old ledger effect if it was unpaid
    if (!oldBill.isPaid) {
      customerProvider.addTransaction(oldBill.customerName, {
        'amount': oldBill.grandTotal,
        'note': 'Bill Edited Removed',
        'date': DateTime.now(),
        'type': 'RECEIVED', // reverse entry
      });
    }

    /// replace bill
    _bills[index] = updatedBill;

    /// apply new ledger effect if unpaid
    if (!updatedBill.isPaid) {
      customerProvider.addTransaction(updatedBill.customerName, {
        'amount': updatedBill.grandTotal,
        'note': 'Bill ${updatedBill.billNo}',
        'date': DateTime.now(),
        'type': 'GIVEN',
      });
    }

    notifyListeners();
  }

  /// 💰 TOGGLE PAID / UNPAID
  void togglePaid(BillModel bill, CustomerProvider customerProvider) {
    final index = _bills.indexWhere((b) => b.id == bill.id);
    if (index == -1) return;

    _bills[index].isPaid = !_bills[index].isPaid;

    if (_bills[index].isPaid) {
      /// paid → remove from ledger
      customerProvider.addTransaction(bill.customerName, {
        'amount': bill.grandTotal,
        'note': 'Bill Paid',
        'date': DateTime.now(),
        'type': 'RECEIVED',
      });
    } else {
      /// unpaid → add back to ledger
      customerProvider.addTransaction(bill.customerName, {
        'amount': bill.grandTotal,
        'note': 'Bill Unpaid',
        'date': DateTime.now(),
        'type': 'GIVEN',
      });
    }

    notifyListeners();
  }

  /// 🗑 DELETE BILL
  void deleteBill(BillModel bill, CustomerProvider customerProvider) {
    _bills.removeWhere((b) => b.id == bill.id);

    if (!bill.isPaid) {
      customerProvider.addTransaction(bill.customerName, {
        'amount': bill.grandTotal,
        'note': 'Bill Deleted',
        'date': DateTime.now(),
        'type': 'RECEIVED',
      });
    }

    notifyListeners();
  }
}
