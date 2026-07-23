# Distribution UI v1 — Integration Report

## Added

- Responsive distribution orders screen
- Filters for all, confirmed, and received orders
- Loading, empty, network/server error, and retry states
- Pull-to-refresh
- Responsive order details screen
- Delivery, wallet, driver, trip, proof, and order-line information
- Routes:
  - `/distribution/orders`
  - `/distribution/order?name=...`
- Four-language localization for the new UI
- Compact-screen widget tests

## Home integration

The existing Home geometry and 3D side-menu animation are preserved.

Distribution opens from:

1. The cargo-services card
2. The truck icon in the Home bottom navigation

Returning to Home restores the first bottom-navigation item.

## Unchanged

- Authentication and OTP
- Auth storage
- HomeScreen transform constants
- SideMenu layout
- Onboarding
- Gateway and Odoo
- Existing Distribution Foundation models/repository/controllers

## API path

The UI continues to use:

```text
Flutter → Platform API Gateway → Odoo Clone
```

It does not connect directly to Odoo.
