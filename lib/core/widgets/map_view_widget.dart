import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_colors.dart';

enum CarPhase { none, approaching, waiting, riding, arrived }

class MapViewWidget extends StatefulWidget {
  final bool showRoute;
  final CarPhase phase;
  final LatLng? routeTo;
  final ValueChanged<LatLng>? onTap;

  const MapViewWidget({
    super.key,
    required this.showRoute,
    required this.phase,
    required this.routeTo,
    this.onTap,
  });

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget>
    with SingleTickerProviderStateMixin {
  final _map = MapController();
  late final AnimationController _car;

  static const _pickup = LatLng(43.0015, 41.0234);
  static const _approachRoute = [
    LatLng(43.0058, 41.0312),
    LatLng(43.0040, 41.0268),
    _pickup,
  ];

  bool get _moving =>
      widget.phase == CarPhase.approaching || widget.phase == CarPhase.riding;

  @override
  void initState() {
    super.initState();
    _car = AnimationController(
        vsync: this, duration: const Duration(seconds: 5));
    if (_moving) _car.repeat();
  }

  @override
  void didUpdateWidget(covariant MapViewWidget old) {
    super.didUpdateWidget(old);
    if (_moving && !_car.isAnimating) {
      _car.repeat();
    } else if (!_moving && _car.isAnimating) {
      _car.stop();
      _car.value = 0;
    }
  }

  @override
  void dispose() {
    _car.dispose();
    super.dispose();
  }

  LatLng _along(List<LatLng> pts, double t) {
    if (t <= 0) return pts.first;
    if (t >= 1) return pts.last;
    final n = pts.length - 1;
    final scaled = t * n;
    final i = scaled.floor();
    final f = scaled - i;
    final a = pts[i];
    final b = pts[i + 1];
    return LatLng(
      a.latitude + (b.latitude - a.latitude) * f,
      a.longitude + (b.longitude - a.longitude) * f,
    );
  }

  LatLng? _carPos() {
    switch (widget.phase) {
      case CarPhase.none:
        return null;
      case CarPhase.approaching:
        return _along(_approachRoute, _car.value);
      case CarPhase.waiting:
        return _pickup;
      case CarPhase.riding:
        return _along([_pickup, widget.routeTo ?? _pickup], _car.value);
      case CarPhase.arrived:
        return widget.routeTo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _car,
      builder: (context, _) {
        final carPos = _carPos();
        return FlutterMap(
          mapController: _map,
          options: MapOptions(
            initialCenter: const LatLng(43.006, 41.030),
            initialZoom: 13.5,
            onTap: widget.onTap == null
                ? null
                : (tapPos, point) => widget.onTap!(point),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.taxi',
            ),
            if (widget.showRoute && widget.routeTo != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [_pickup, widget.routeTo!],
                    strokeWidth: 5,
                    color: AppColors.primary,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _pickup,
                  width: 24,
                  height: 24,
                  child: Image.asset('assets/icons/pickup_dot.png'),
                ),
                if (widget.routeTo != null)
                  Marker(
                    point: widget.routeTo!,
                    width: 32,
                    height: 32,
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/icons/destination_pin.png'),
                  ),
                if (carPos != null)
                  Marker(
                    point: carPos,
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/icons/car_top_view.png'),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}