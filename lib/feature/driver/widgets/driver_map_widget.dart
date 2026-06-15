import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/driver_cubit.dart';


class DriverMapWidget extends StatefulWidget {
  final DriverOrder? order;
  const DriverMapWidget({super.key, required this.order});

  @override
  State<DriverMapWidget> createState() => _DriverMapWidgetState();
}

class _DriverMapWidgetState extends State<DriverMapWidget> {
  final _map = MapController();
  static const _driver = LatLng(43.0030, 41.0270);

  @override
  void didUpdateWidget(covariant DriverMapWidget old) {
    super.didUpdateWidget(old);
    if (widget.order != old.order) _scheduleFit();
  }

  void _scheduleFit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final o = widget.order;
      if (o == null) {
        _map.move(_driver, 15);
        return;
      }
      final bounds = LatLngBounds.fromPoints([_driver, o.pickupPoint, o.destPoint]);
      _map.fitCamera(CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.only(left: 50, right: 50, top: 150, bottom: 300),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return FlutterMap(
      mapController: _map,
      options: const MapOptions(initialCenter: LatLng(43.0023, 41.0252), initialZoom: 14.5),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.taxi',
        ),
        if (o != null)
          PolylineLayer(
            polylines: [
              Polyline(points: [_driver, o.pickupPoint], strokeWidth: 4, color: AppColors.textSecondary),
              Polyline(points: [o.pickupPoint, o.destPoint], strokeWidth: 5, color: AppColors.primary),
            ],
          ),
        MarkerLayer(
          markers: [
            const Marker(point: _driver, width: 42, height: 42, child: _CarPuckWidget()),
            if (o != null) ...[
              Marker(point: o.pickupPoint, width: 40, height: 40, child: const _ClientPinWidget()),
              Marker(point: o.destPoint, width: 40, height: 40, alignment: Alignment.topCenter,
                  child: const Icon(Icons.location_on_rounded, color: AppColors.error, size: 38)),
            ],
          ],
        ),
      ],
    );
  }
}

class _ClientPinWidget extends StatelessWidget {
  const _ClientPinWidget();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.success, shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
    );
  }
}

class _CarPuckWidget extends StatelessWidget {
  const _CarPuckWidget();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent, shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: const Icon(Icons.local_taxi_rounded, color: AppColors.primaryDark, size: 22),
    );
  }
}