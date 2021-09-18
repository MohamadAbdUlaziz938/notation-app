import 'file-transfer.dart';
const Map<TransferQueueStatus,int> notifIdsDownload = {
  TransferQueueStatus.completed: 59658450,
  TransferQueueStatus.inProgress: 59658451,
  TransferQueueStatus.paused: 59658452,
  TransferQueueStatus.error:59658453,
};
const Map<TransferQueueStatus,int> notifIdsUpload = {
  TransferQueueStatus.completed: 69658450,
  TransferQueueStatus.inProgress: 69658451,
  TransferQueueStatus.paused: 69658453,
  TransferQueueStatus.error:69658454,
};
const Map<TransferQueueStatus,int> notifIdsOffline = {
  TransferQueueStatus.completed: 79658450,
  TransferQueueStatus.inProgress: 79658451,
  TransferQueueStatus.paused: 79658453,
  TransferQueueStatus.error:79658454,
};