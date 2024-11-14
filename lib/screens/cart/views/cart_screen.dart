import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_bloc.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_event.dart';
import 'package:food_app/screens/cart/blocs/bloc/cart_state.dart';
import 'package:food_repository/food_repository.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100, 
      appBar: AppBar(
        title: const Text('Meu Carrinho'),
        backgroundColor: Colors.transparent, 
      ),
      body: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(20, -1.2),
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber.shade200,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(2.7, -1.2),
            child: Container(
              height: MediaQuery.of(context).size.width / 1.3,
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.shade400,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartInitial || (state is CartUpdated && state.items.isEmpty)) {
                  return const Center(
                    child: Text(
                      'Seu carrinho está vazio!',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else if (state is CartUpdated) {
                  return FutureBuilder<List<Food>>(
                    future: context.read<CartBloc>().getFoods(),
                    builder: (context, foodSnapshot) {
                      if (foodSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (foodSnapshot.hasError) {
                        return Center(
                          child: Text(
                            'Erro ao carregar os alimentos: ${foodSnapshot.error}',
                            style: const TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        );
                      }

                      final foodList = foodSnapshot.data ?? [];

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.items.length,
                              itemBuilder: (context, index) {
                                final cartItem = state.items[index];
                                final food = foodList.firstWhere(
                                  (food) => food.foodId == cartItem.foodId
                                );
                                return ListTile(
                                  leading: food.picture.isNotEmpty
                                      ? Image.network(
                                          food.picture,
                                          width: 50,
                                          height: 50,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.error);
                                          },
                                        )
                                      : const Icon(Icons.food_bank),
                                  title: Text(food.name),
                                  subtitle: Text(
                                    'Quantidade: ${cartItem.quantity}\nPreço: R\$ ${(food.price * cartItem.quantity).toStringAsFixed(2)}',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      context
                                          .read<CartBloc>()
                                          .add(RemoveFromCartEvent(food));
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'Total: R\$ ${(state.items.fold(0.0, (total, cartItem) {
                                final food = foodList.firstWhere(
                                  (food) => food.foodId == cartItem.foodId,
                                );
                                return total + (food.price * cartItem.quantity);
                              })).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text(
                              'Finalizar Compra',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else if (state is CartError) {
                  return Center(
                    child: Text(
                      'Erro: ${state.message}',
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
