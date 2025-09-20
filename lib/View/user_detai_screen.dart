import 'package:flutter/material.dart';
import '../Model/user_response_model.dart';

class UserDetailScreen extends StatefulWidget {
  final User userModel;
  const UserDetailScreen({super.key, required this.userModel});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userModel.firstName} ${widget.userModel.lastName}'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Image and Basic Info
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.userModel.image),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.userModel.firstName} ${widget.userModel.lastName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    '(${widget.userModel.maidenName})',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Role: ${widget.userModel.role}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          // Personal Information
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Age'),
                  subtitle: Text('${widget.userModel.age}'),
                ),
                ListTile(
                  leading: const Icon(Icons.transgender),
                  title: const Text('Gender'),
                  subtitle: Text(widget.userModel.gender),
                ),
                ListTile(
                  leading: const Icon(Icons.cake),
                  title: const Text('Birth Date'),
                  subtitle: Text(widget.userModel.birthDate),
                ),
                ListTile(
                  leading: const Icon(Icons.bloodtype),
                  title: const Text('Blood Group'),
                  subtitle: Text(widget.userModel.bloodGroup),
                ),
                ListTile(
                  leading: const Icon(Icons.height),
                  title: const Text('Height'),
                  subtitle: Text('${widget.userModel.height} cm'),
                ),
                ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: const Text('Weight'),
                  subtitle: Text('${widget.userModel.weight} kg'),
                ),
                ListTile(
                  leading: const Icon(Icons.remove_red_eye),
                  title: const Text('Eye Color'),
                  subtitle: Text(widget.userModel.eyeColor),
                ),
                ListTile(
                  leading: const Icon(Icons.face),
                  title: const Text('Hair'),
                  subtitle: Text('${widget.userModel.hair.color} (${widget.userModel.hair.type})'),
                ),
              ],
            ),
          ),
          // Contact Information
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text(widget.userModel.email),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Phone'),
                  subtitle: Text(widget.userModel.phone),
                ),
                ListTile(
                  leading: const Icon(Icons.person_pin),
                  title: const Text('Username'),
                  subtitle: Text(widget.userModel.username),
                ),
              ],
            ),
          ),
          // Address Information
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Address'),
                  subtitle: Text(
                    '${widget.userModel.address.address}, ${widget.userModel.address.city}, '
                        '${widget.userModel.address.state}, ${widget.userModel.address.postalCode}, '
                        '${widget.userModel.address.country}',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Coordinates'),
                  subtitle: Text(
                    'Lat: ${widget.userModel.address.coordinates.lat}, Lng: ${widget.userModel.address.coordinates.lng}',
                  ),
                ),
              ],
            ),
          ),
          // Professional Information
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('University'),
                  subtitle: Text(widget.userModel.university),
                ),
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text('Company'),
                  subtitle: Text(
                    '${widget.userModel.company.name} (${widget.userModel.company.department})',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text('Title'),
                  subtitle: Text(widget.userModel.company.title),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: const Text('Company Address'),
                  subtitle: Text(
                    '${widget.userModel.company.address.address}, ${widget.userModel.company.address.city}, '
                        '${widget.userModel.company.address.state}, ${widget.userModel.company.address.postalCode}, '
                        '${widget.userModel.company.address.country}',
                  ),
                ),
              ],
            ),
          ),
          // Bank Information
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Card Type'),
                  subtitle: Text(widget.userModel.bank.cardType),
                ),
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: const Text('Card Expiry'),
                  subtitle: Text(widget.userModel.bank.cardExpire),
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance),
                  title: const Text('Currency'),
                  subtitle: Text(widget.userModel.bank.currency),
                ),
              ],
            ),
          ),
          // Other Information
          Card(
            elevation: 4,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.vpn_key),
                  title: const Text('EIN'),
                  subtitle: Text(widget.userModel.ein),
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('SSN'),
                  subtitle: Text(widget.userModel.ssn),
                ),
                ListTile(
                  leading: const Icon(Icons.currency_bitcoin),
                  title: const Text('Crypto'),
                  subtitle: Text(
                    '${widget.userModel.crypto.coin} (${widget.userModel.crypto.network})',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
