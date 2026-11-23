import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/family_member.dart';
import '../services/api_service.dart';
import '../widgets/app_avatar.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final ApiService _api = ApiService();
  final ImagePicker _picker = ImagePicker();
  List<FamilyMember> _members = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final members = await _api.getFamilyMembers();
      if (!mounted) return;
      setState(() {
        _members = members;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  Color _getRelationColor(String relation) {
    switch (relation.toLowerCase()) {
      case 'père':
        return const Color(0xFF1E3A8A);
      case 'mère':
        return const Color(0xFFDB2777);
      case 'grand frère':
        return const Color(0xFF0D9488);
      case 'petite sœur':
        return const Color(0xFFD97706);
      case 'oncle':
        return const Color(0xFF6D28D9);
      case 'tante':
        return const Color(0xFFBE185D);
      default:
        return Colors.blueGrey;
    }
  }

  Future<void> _showMemberForm({FamilyMember? member}) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MemberFormSheet(
        member: member,
        api: _api,
        picker: _picker,
      ),
    );
    if (saved == true) await _loadMembers();
  }

  Future<void> _confirmDelete(FamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le membre'),
        content: Text('Voulez-vous supprimer ${member.fullName} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _api.deleteFamilyMember(member.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membre supprimé')),
      );
      await _loadMembers();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _showDetails(FamilyMember member) {
    final relationColor = _getRelationColor(member.relation);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAvatar(
              imageUrl: member.imageUrl,
              name: member.fullName,
              radius: 46,
              borderColor: relationColor,
              borderWidth: 3,
            ),
            const SizedBox(height: 12),
            Text(
              member.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Chip(
              label: Text(member.relation),
              backgroundColor: relationColor.withValues(alpha: 0.12),
              side: BorderSide.none,
            ),
            const SizedBox(height: 12),
            _DetailRow(icon: Icons.location_on_outlined, label: 'Lieu de naissance', value: member.birthPlace),
            _DetailRow(icon: Icons.cake_outlined, label: 'Date de naissance', value: member.birthDate),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showMemberForm(member: member);
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Modifier'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(member);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Supprimer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMemberForm(),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Ajouter'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadMembers,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.cloud_off_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: _loadMembers, child: const Text('Réessayer')),
        ],
      );
    }
    if (_members.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 160),
          Icon(Icons.family_restroom, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Aucun membre de famille', textAlign: TextAlign.center),
        ],
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final member = _members[index];
        final relationColor = _getRelationColor(member.relation);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            onTap: () => _showDetails(member),
            leading: AppAvatar(
              imageUrl: member.imageUrl,
              name: member.fullName,
              radius: 32,
              borderColor: relationColor,
              borderWidth: 2,
            ),
            title: Text(
              member.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('${member.relation} • ${member.birthPlace}\n${member.birthDate}'),
            ),
            isThreeLine: true,
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showMemberForm(member: member);
                } else {
                  _confirmDelete(member);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Modifier')),
                PopupMenuItem(value: 'delete', child: Text('Supprimer')),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.teal.shade700),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _MemberFormSheet extends StatefulWidget {
  final FamilyMember? member;
  final ApiService api;
  final ImagePicker picker;

  const _MemberFormSheet({
    required this.member,
    required this.api,
    required this.picker,
  });

  @override
  State<_MemberFormSheet> createState() => _MemberFormSheetState();
}

class _MemberFormSheetState extends State<_MemberFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _postName;
  late final TextEditingController _firstName;
  late final TextEditingController _birthPlace;
  late final TextEditingController _relation;
  DateTime? _birthDate;
  XFile? _image;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.member?.name);
    _postName = TextEditingController(text: widget.member?.postName);
    _firstName = TextEditingController(text: widget.member?.firstName);
    _birthPlace = TextEditingController(text: widget.member?.birthPlace);
    _relation = TextEditingController(text: widget.member?.relation);
    if (widget.member?.birthDate.isNotEmpty == true) {
      _birthDate = DateTime.tryParse(widget.member!.birthDate);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _postName.dispose();
    _firstName.dispose();
    _birthPlace.dispose();
    _relation.dispose();
    super.dispose();
  }

  String get _dateText => _birthDate == null
      ? ''
      : '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}';

  String? _required(TextEditingController controller) =>
      controller.text.trim().isEmpty ? 'Ce champ est obligatoire' : null;

  Future<void> _pickImage() async {
    final image = await widget.picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) setState(() => _image = image);
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _birthDate = date);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir la date de naissance')),
      );
      return;
    }
    setState(() => _isSaving = true);
    final member = FamilyMember(
      id: widget.member?.id ?? 0,
      name: _name.text.trim(),
      postName: _postName.text.trim(),
      firstName: _firstName.text.trim(),
      birthPlace: _birthPlace.text.trim(),
      birthDate: _dateText,
      relation: _relation.text.trim(),
      imageUrl: widget.member?.imageUrl,
    );
    try {
      if (_image != null) {
        final bytes = await _image!.readAsBytes();
        if (widget.member == null) {
          await widget.api.createFamilyMemberWithImage(
            member: member,
            bytes: bytes,
            fileName: _image!.name,
          );
        } else {
          await widget.api.updateFamilyMemberWithImage(
            member: member,
            bytes: bytes,
            fileName: _image!.name,
          );
        }
      } else if (widget.member == null) {
        await widget.api.createFamilyMember(member: member);
      } else {
        await widget.api.updateFamilyMember(member);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.member == null ? 'Ajouter un membre' : 'Modifier le membre',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isSaving ? null : _pickImage,
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(_image == null ? 'Choisir une photo' : _image!.name),
              ),
              const SizedBox(height: 12),
              _Field(controller: _name, label: 'Nom', validator: _required),
              _Field(controller: _postName, label: 'Post-nom', validator: _required),
              _Field(controller: _firstName, label: 'Prénom', validator: _required),
              _Field(controller: _birthPlace, label: 'Lieu de naissance', validator: _required),
              _Field(controller: _relation, label: 'Lien de parenté', hint: 'Père, Mère, Frère...', validator: _required),
              OutlinedButton.icon(
                onPressed: _isSaving ? null : _pickDate,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(_birthDate == null ? 'Date de naissance' : _dateText),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(widget.member == null ? 'Ajouter' : 'Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(TextEditingController) validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.validator,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (_) => validator(controller),
      ),
    );
  }
}
