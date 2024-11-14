// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_event.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_state.dart';
import 'package:food_repository/food_repository.dart';
import 'package:user_repository/user_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _items = [];
  final UserRepository _userRepository;
  final FirebaseFoodRepo _foodRepository;

  CartBloc(this._userRepository, this._foodRepository) : super(CartInitial()) {
    _loadUserCart();

    on<AddToCartEvent>((event, emit) async {
      try {
        final quantity = event.quantity;
        final priceInCents = event.food.priceInCents ?? 0;

        final existingItem = _items.firstWhere(
          (item) => item.foodId == event.food.foodId,
          orElse: () => CartItem(
            foodId: event.food.foodId,
            quantity: quantity,
            priceInCents: priceInCents,
          ),
        );

        if (_items.contains(existingItem)) {
          existingItem.quantity += quantity;
        } else {
          _items.add(CartItem(
            foodId: event.food.foodId,
            quantity: quantity,
            priceInCents: priceInCents,
          ));
        }

        emit(CartUpdated(List.from(_items)));
        await _updateUserCart();
      } catch (e) {
        emit(CartError("Falha para adicionar ao carrinho"));
      }
    });

    on<RemoveFromCartEvent>((event, emit) async {
      try {
        _items.removeWhere((item) => item.foodId == event.food.foodId);
        emit(CartUpdated(List.from(_items)));
        await _updateUserCart();
      } catch (e) {
        emit(CartError("Falha para remover do carrinho"));
      }
    });

    on<UpdateQuantityEvent>((event, emit) async {
      try {
        final item = _items.firstWhere((item) => item.foodId == event.food.foodId);
        item.quantity = event.quantity;
        emit(CartUpdated(List.from(_items)));
        await _updateUserCart();
      } catch (e) {
        emit(CartError("Falha para atualizar a quantidade"));
      }
    });

    on<ClearCartEvent>((event, emit) async {
      _items.clear();
      emit(CartUpdated(List.from(_items)));
      await _updateUserCart();
    });
  }

  Future<void> _loadUserCart() async {
    try {
      final user = await _userRepository.getCurrentUser();
      _items.clear();
      _items.addAll(user.cart.items);
      emit(CartUpdated(List.from(_items)));
    } catch (e) {
      emit(CartError("Fala ao carregar carrinho do usuário"));
    }
  }

  Future<void> _updateUserCart() async {
    try {
      final user = await _userRepository.getCurrentUser();
      user.cart = Cart(items: List.from(_items));
      await _userRepository.updateUserCart(user);
    } catch (e) {
      emit(CartError("Falha ao adicionar no banco de dados"));
    }
  }

  Future<List<Food>> getFoods() async {
    return await _foodRepository.getFood();
  }
}
