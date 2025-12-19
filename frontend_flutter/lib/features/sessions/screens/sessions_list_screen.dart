import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/session.dart';
import '../../../data/services/session_service.dart';

class SessionsListScreen extends StatefulWidget {
  const SessionsListScreen({super.key});

  @override
  State<SessionsListScreen> createState() => _SessionsListScreenState();
}

class _SessionsListScreenState extends State<SessionsListScreen>
    with SingleTickerProviderStateMixin {
  final SessionService _sessionService = SessionService();
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;
  List<Session> _allSessions = [];
  List<Session> _filteredSessions = [];
  bool _isLoading = true;
  String? _selectedGroup;
  List<String> _groups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      _loadSessionsByTab();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final groups = await _sessionService.getAllGroups();

      setState(() {
        _groups = ['Tous', ...groups];
        _isLoading = false;
      });

      await _loadSessionsByTab();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _loadSessionsByTab() async {
    setState(() => _isLoading = true);

    try {
      List<Session> sessions;

      switch (_tabController.index) {
        case 0: // Today
          sessions = await _sessionService.getTodaySessions();
          break;
        case 1: // Upcoming
          sessions = await _sessionService.getUpcomingSessions();
          break;
        case 2: // Past
          sessions = await _sessionService.getPastSessions();
          break;
        default:
          sessions = [];
      }

      setState(() {
        _allSessions = sessions;
        _filteredSessions = sessions;
        _isLoading = false;
      });

      _filterSessions();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterSessions() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredSessions = _allSessions.where((session) {
        final matchesSearch =
            query.isEmpty ||
            session.module.toLowerCase().contains(query) ||
            session.professorName.toLowerCase().contains(query) ||
            session.group.toLowerCase().contains(query) ||
            session.room.toLowerCase().contains(query);

        final matchesGroup =
            _selectedGroup == null ||
            _selectedGroup == 'Tous' ||
            session.group == _selectedGroup;

        return matchesSearch && matchesGroup;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppConstants.sessions,
      body: Column(
        children: [
          // Tabs
          Container(
            color: AppColors.primary,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Aujourd\'hui'),
                Tab(text: 'À venir'),
                Tab(text: 'Passées'),
              ],
            ),
          ),

          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '${AppConstants.search}...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterSessions();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => _filterSessions(),
                ),
                const SizedBox(height: 12),

                // Group Filter
                if (_groups.isNotEmpty)
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _groups.length,
                      itemBuilder: (context, index) {
                        final group = _groups[index];
                        final isSelected =
                            _selectedGroup == group ||
                            (_selectedGroup == null && group == 'Tous');

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(group),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedGroup = group == 'Tous' ? null : group;
                              });
                              _filterSessions();
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            checkmarkColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Sessions List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSessionsList(),
                _buildSessionsList(),
                _buildSessionsList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fonctionnalité à venir')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSessionsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredSessions.isEmpty) {
      return EmptyStateWidget(
        message: _searchController.text.isEmpty
            ? 'Aucune séance'
            : 'Aucune séance trouvée',
        icon: Icons.event_busy,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSessionsByTab,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredSessions.length,
        itemBuilder: (context, index) {
          final session = _filteredSessions[index];
          return _SessionCard(
            session: session,
            onTap: () => context.push('/sessions/${session.id}'),
          );
        },
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Session session;
  final VoidCallback onTap;

  const _SessionCard({required this.session, required this.onTap});

  Color get _statusColor {
    if (session.isToday) return AppColors.success;
    if (session.isFuture) return AppColors.info;
    return AppColors.textSecondary;
  }

  String get _statusLabel {
    if (session.isToday) return 'Aujourd\'hui';
    if (session.isFuture) return 'À venir';
    return 'Terminée';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      session.module,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Professor
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    session.professorName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date and Time
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat(
                      'EEEE d MMMM yyyy',
                      'fr_FR',
                    ).format(session.date),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Time, Room, Group
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${session.startTime} - ${session.endTime}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.room,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    session.room,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Group
              Row(
                children: [
                  const Icon(
                    Icons.group,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    session.group,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
