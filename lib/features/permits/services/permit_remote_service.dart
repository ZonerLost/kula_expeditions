import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/permit_model.dart';
import '../models/permit_request_model.dart';

class PermitRemoteService {
  PermitRemoteService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _uuid = const Uuid();

  final FirebaseFirestore _firestore;
  final Uuid _uuid;
  static const String _collectionName = 'permits';

  Future<PermitModel> createPermitRequest(PermitRequestModel request) async {
    final documentId = _uuid.v4();
    final permitId = _generatePermitId();
    final now = FieldValue.serverTimestamp();
    final localNow = DateTime.now();

    final payload = <String, dynamic>{
      ...request.toMap(),
      'permitId': permitId,
      'status': 'pending',
      'paymentStatus': 'unpaid',
      'amountPaid': request.amountPaid,
      'passportUrl': request.passportUrl,
      'visaUrl': request.visaUrl,
      'createdAt': now,
      'submittedAt': now,
      'updatedAt': now,
      'userId': request.userId,
    };

    try {
      debugPrint(
        '[PermitRemoteService] Writing to Firestore collection="$_collectionName" docId="$documentId" permitId="$permitId"',
      );
      await _firestore.collection(_collectionName).doc(documentId).set(payload);
      debugPrint(
        '[PermitRemoteService] Firestore write success for docId="$documentId", permitId="$permitId"',
      );
    } on FirebaseException catch (error) {
      debugPrint(
        '[PermitRemoteService][FirebaseException] code=${error.code}, message=${error.message}',
      );
      debugPrint(
        '[PermitRemoteService][FirebaseException] stack=${error.stackTrace}',
      );
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('[PermitRemoteService][Exception] error=$error');
      debugPrint('[PermitRemoteService][Exception] stack=$stackTrace');
      rethrow;
    }

    // Avoid immediate read-after-write so submission can still succeed
    // when rules allow writes but restrict reads.
    return PermitModel(
      amountPaid: request.amountPaid,
      borderPoint: request.borderPoint,
      createdAt: localNow,
      crossingDate: request.crossingDate,
      email: request.email,
      emergencyContact: request.emergencyContact,
      endDate: request.endDate,
      fromCountry: request.fromCountry,
      fullName: request.fullName,
      hasDiscount: request.hasDiscount,
      nationality: request.nationality,
      needsVisa: request.needsVisa,
      passportNumber: request.passportNumber,
      passportUrl: request.passportUrl,
      paymentStatus: 'unpaid',
      permitId: permitId,
      startDate: request.startDate,
      status: 'pending',
      submittedAt: localNow,
      toCountry: request.toCountry,
      updatedAt: localNow,
      userId: request.userId,
      visaUrl: request.visaUrl,
    );
  }

  Future<void> updatePermitDocumentUrls({
    required String permitId,
    String? passportUrl,
    String? visaUrl,
  }) async {
    final cleanPermitId = permitId.trim();
    if (cleanPermitId.isEmpty) {
      throw ArgumentError.value(permitId, 'permitId', 'must not be empty');
    }

    final patch = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
    if (passportUrl != null) {
      patch['passportUrl'] = passportUrl;
    }
    if (visaUrl != null) {
      patch['visaUrl'] = visaUrl;
    }
    if (patch.length == 1) {
      return;
    }

    final query = await _firestore
        .collection(_collectionName)
        .where('permitId', isEqualTo: cleanPermitId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw StateError('Permit not found for permitId="$cleanPermitId".');
    }

    await query.docs.first.reference.update(patch);
  }

  Future<List<PermitModel>> getPermitsByIds(List<String> permitIds) async {
    if (permitIds.isEmpty) {
      return <PermitModel>[];
    }

    final byPermitId = <String, PermitModel>{};
    final docs = await Future.wait(
      permitIds.map(
        (id) => _firestore.collection(_collectionName).doc(id).get(),
      ),
    );

    for (final doc in docs) {
      if (!doc.exists) {
        continue;
      }
      final data = doc.data();
      if (data == null) {
        continue;
      }
      final permit = PermitModel.fromMap(data);
      if (permit.permitId.isNotEmpty) {
        byPermitId[permit.permitId] = permit;
      }
    }

    final missingIds = permitIds
        .where((id) => !byPermitId.containsKey(id))
        .toList();
    for (int i = 0; i < missingIds.length; i += 10) {
      final chunk = missingIds.sublist(
        i,
        i + 10 > missingIds.length ? missingIds.length : i + 10,
      );

      final query = await _firestore
          .collection(_collectionName)
          .where('permitId', whereIn: chunk)
          .get();

      for (final doc in query.docs) {
        final permit = PermitModel.fromMap(doc.data());
        if (permit.permitId.isNotEmpty) {
          byPermitId[permit.permitId] = permit;
        }
      }
    }

    final orderedPermits = <PermitModel>[];
    for (final id in permitIds) {
      final permit = byPermitId[id];
      if (permit != null) {
        orderedPermits.add(permit);
      }
    }
    return orderedPermits;
  }

  Future<PermitModel?> getPermitById(String permitId) async {
    if (permitId.trim().isEmpty) {
      return null;
    }

    final doc = await _firestore
        .collection(_collectionName)
        .doc(permitId)
        .get();
    if (doc.exists && doc.data() != null) {
      return PermitModel.fromMap(doc.data()!);
    }

    final query = await _firestore
        .collection(_collectionName)
        .where('permitId', isEqualTo: permitId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return PermitModel.fromMap(query.docs.first.data());
  }

  String _generatePermitId() {
    final random = Random.secure();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    String randomChunk() {
      return List<String>.generate(
        4,
        (_) => chars[random.nextInt(chars.length)],
      ).join();
    }

    return 'BLK-${randomChunk()}-${randomChunk()}';
  }
}
