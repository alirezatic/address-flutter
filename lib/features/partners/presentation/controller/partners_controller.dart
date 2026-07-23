import 'package:flutter/foundation.dart';

import 'package:address/features/partners/domain/models/partner_category.dart';

class PartnersController extends ChangeNotifier {
  PartnersController({required this.category});

  final PartnerCategoryDefinition category;

  PartnerDriverMode _driverMode = PartnerDriverMode.personal;
  PartnerItemId? _primaryItemId;
  final Set<PartnerItemId> _selectedItemIds = <PartnerItemId>{};

  PartnerDriverMode get driverMode => _driverMode;
  PartnerItemId? get primaryItemId => _primaryItemId;
  Set<PartnerItemId> get selectedItemIds =>
      Set<PartnerItemId>.unmodifiable(_selectedItemIds);

  int get selectionCount =>
      (_primaryItemId == null ? 0 : 1) + _selectedItemIds.length;

  bool get canSubmit {
    return switch (category.selectionMode) {
      PartnerSelectionMode.primarySecondary => _primaryItemId != null,
      PartnerSelectionMode.multiple => _selectedItemIds.isNotEmpty,
      PartnerSelectionMode.driver =>
        _driverMode == PartnerDriverMode.personal
            ? _primaryItemId != null
            : _selectedItemIds.isNotEmpty,
    };
  }

  bool isPrimary(PartnerItemId id) => _primaryItemId == id;
  bool isSelected(PartnerItemId id) => _selectedItemIds.contains(id);

  void selectItem(PartnerItemId id) {
    switch (category.selectionMode) {
      case PartnerSelectionMode.primarySecondary:
        if (_primaryItemId == null || _primaryItemId == id) {
          _togglePrimary(id);
        } else {
          _toggleSelected(id);
        }
        break;
      case PartnerSelectionMode.multiple:
        _toggleSelected(id);
        break;
      case PartnerSelectionMode.driver:
        if (_driverMode == PartnerDriverMode.personal) {
          _togglePrimary(id);
        } else {
          _toggleSelected(id);
        }
        break;
    }
    notifyListeners();
  }

  void changeDriverMode(PartnerDriverMode mode) {
    if (_driverMode == mode) {
      return;
    }

    _driverMode = mode;
    _primaryItemId = null;
    _selectedItemIds.clear();
    notifyListeners();
  }

  PartnerSelectionResult buildResult() {
    return PartnerSelectionResult(
      categoryId: category.id,
      driverMode: _driverMode,
      primaryItemId: _primaryItemId,
      selectedItemIds: Set<PartnerItemId>.unmodifiable(_selectedItemIds),
    );
  }

  void _togglePrimary(PartnerItemId id) {
    if (_primaryItemId == id) {
      _primaryItemId = null;
      return;
    }

    _primaryItemId = id;
    _selectedItemIds.remove(id);
  }

  void _toggleSelected(PartnerItemId id) {
    if (!_selectedItemIds.add(id)) {
      _selectedItemIds.remove(id);
    }
  }
}
