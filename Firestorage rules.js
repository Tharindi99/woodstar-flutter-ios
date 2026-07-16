// rules_version = '2';

// // Deploy: firebase deploy --only firestore:rules

// service cloud.firestore {
//   match /databases/{database}/documents {

//     match /qrSounds/{soundId} {
//       allow read: if true;
//       allow write: if false;
//     }

//     function validNick(n) {
//       return n.matches('^[A-Za-z0-9 ]{4,30}$');
//     }

//     match /users/{nickId} {
//       allow read: if true;

//       // New profile: nickname only (same as doc id).
//       allow create: if validNick(nickId)
//           && request.resource.data.keys().hasOnly(['nickname'])
//           && request.resource.data.nickname == nickId;

//       // Updates: nickname unchanged + optional QR career stats (written by the app after a hunt).
//       allow update: if validNick(nickId)
//           && request.resource.data.nickname == nickId
//           && request.resource.data.keys().hasOnly([
//             'nickname',
//             'gamesPlayed',
//             'wins',
//             'totalScore',
//             'bestStreak',
//             'bestAccuracy',
//             'bestTime',
//             'createdAt',
//           ]);

//       allow delete: if false;
//     }
//   }
// }


