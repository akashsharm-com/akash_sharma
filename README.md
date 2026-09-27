# AK INTERIOR DESIGN — GitHub + Supabase + Direct Media Upload

## Features
### Customer
- Public website without login
- Services
- Projects
- Completed projects
- Photo/video gallery
- Contact section

### Manager
- Supabase email/password login
- Dashboard
- Add/delete projects
- **Direct photo upload**
- **Direct video upload**
- Delete uploaded media
- Worker records
- Worker payment records

## Setup
1. Create a Supabase project.
2. Open Supabase -> SQL Editor.
3. Run `supabase.sql`.
4. Supabase -> Authentication -> Users -> Add user.
5. Create your manager email/password.
6. Open `index.html`.
7. Replace:
   `YOUR_SUPABASE_URL`
   `YOUR_SUPABASE_ANON_KEY`
8. Upload `index.html` and `supabase.sql` to GitHub.
9. GitHub -> Settings -> Pages -> Deploy from branch -> main -> root.

## Direct media upload
Manager Dashboard -> Photos / Videos:
1. Enter title.
2. Select Photo or Video.
3. Choose file.
4. Click Upload File.
5. The file is uploaded to Supabase Storage bucket `ak-media`.
6. A public media record is saved in the `media` table.
7. Customer gallery automatically reads that record.
8. Delete removes the database record and the Storage file when its URL belongs to the `ak-media` bucket.

Limits in the starter:
- Photo: 15 MB
- Video: 100 MB

You can change these limits in `uploadMediaFile()`.

## Important security note
Do NOT put the Supabase service-role/secret key in `index.html`. Only use the public publishable/anon key.

For a production business site, restrict manager access to an approved manager account/role instead of allowing every authenticated Supabase user to access admin tables.
