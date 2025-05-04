

/*class VehicleSearchScreen extends StatelessWidget {
  VehicleSearchScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vinController = TextEditingController();

  void _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final vin = _vinController.text.trim();
    context.read<AuctionDataBloc>().add(AuctionDataFetched(vin: vin));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Vehicle Search', showOptionMenu: true),
      bottomNavigationBar: BottomNavBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuctionDataBloc, AuctionDataState>(
            listenWhen: (previous, current) {
              /// Only listen when the screen is still in the widget tree
              return ModalRoute.of(context)?.isCurrent ?? false;
            },
            listener: (context, state) {
              if (!context.mounted) return;

              if (state is AuctionDataStateSuccess) {
                final auctionDataEntity = AuctionDataEntity.fromAuctionData(state.auctionData, locale: 'de_DE');
                ScaffoldMessenger.of(context).clearSnackBars();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuctionVehicleDetailsScreen(auctionDataEntity: auctionDataEntity)));

              } else if (state is AuctionDataStateMultipleChoice) {
                ScaffoldMessenger.of(context).clearSnackBars();
                 final vehicleOptionsEntity = VehicleOptionsEntity.fromVehicleOptions(state.vehicleOptionItems);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => VehicleSelectionScreen(vehicleOptionsEntity: vehicleOptionsEntity)));

              } else if (state is AuctionDataStateFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));

              } else if (state is AuctionDataStateException) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
              }
            },
          ),
        ],
        child: BlocBuilder<AuctionDataBloc, AuctionDataState>(
          builder: (context, state) {
            String? errorMessage;
            var isLoading = false;

            if (state is AuctionDataStateFailure) {
              errorMessage = 'A ${state.errorResponse.msgKey} error occurred: ${state.errorResponse.message}';

            } else if (state is AuctionDataStateException) {
              errorMessage = state.errorMessage;

            } else if (state is AuctionDataStateLoading) {
              isLoading = true;
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 32),
                    Text("We'll find your vehicle using the VIN. You might get an exact match or a list of similar results.",
                        style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 32),
                    TextFormField(
                      maxLength: 17,
                      controller: _vinController,
                      decoration: InputDecoration(
                        labelText: "Enter VIN",
                        prefixIcon: Icon(Icons.car_rental_sharp, color: Theme.of(context).colorScheme.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                          ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            _vinController.clear();
                          },
                        ),
                      ),
                      validator: isVinValid,
                    ),
                    const SizedBox(height: 16),

                    if (errorMessage != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
                      ),
                      const SizedBox(height: 18),
                    ],

                    CacheToggleSwitch(),

                    SizedBox(height: 28),
                    isLoading
                        ? CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)
                        : ElevatedButton(
                      onPressed: () => _submit(context),
                      child: const Text('Find auctions for VIN'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


}*/