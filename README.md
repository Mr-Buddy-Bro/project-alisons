# Project Alisons

## Flutter Version Used
- Flutter: `3.41.2` (stable)
- Dart: `3.11.0`

## State Management Used
- `flutter_bloc` (BLoC/Cubit pattern)
- Implemented modules:
  - Auth: `AuthBloc`
  - Home: `HomeBloc`
  - Products list/pagination: `ProductsBloc`
  - Cart (local in-memory): `CartCubit`

## Assumptions Made
- Product/category/banner image URLs may come as filename-only values and are constructed using:
  - `https://sungod.demospro2023.in.net/images/banner/`
  - `https://sungod.demospro2023.in.net/images/product/`
  - `https://sungod.demospro2023.in.net/images/category/`
- Cart feature is intentionally local-only and uses in-memory state (no API sync, no local persistence).

## Known Issues / Limitations
- Cart data is lost when app restarts (in-memory only).
- Several actions are UI-only placeholders (e.g., search, favorites toggle persistence, checkout flow).
- Related products depend on backend response; for many products API currently returns an empty list.
- Some sections still use mocked/fallback UI behavior when backend fields are missing.
