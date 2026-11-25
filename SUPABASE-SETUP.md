# Enable shared photo uploads

The website is hosted on GitHub Pages, so images need a separate storage service
to remain available to everyone after refresh. This project uses Supabase Storage
and its database for the shared album.

## 1. Create the Supabase album

1. Create a Supabase project at <https://supabase.com/dashboard>.
2. Open **SQL Editor**, paste the contents of `supabase-setup.sql`, and run it.
   This creates the public photo bucket, album table, and upload/read policies.
3. In **Project Settings → API**, copy the project URL and the **publishable**
   key. Never use a `service_role` or secret key in this website.

## 2. Connect GitHub Pages

In the `my-web` GitHub repository, open **Settings → Secrets and variables →
Actions → Variables**, then create these repository variables:

| Name | Value |
| --- | --- |
| `SUPABASE_URL` | The Supabase project URL |
| `SUPABASE_PUBLISHABLE_KEY` | The Supabase publishable key |

Push a commit to `main` or run **Deploy static site to GitHub Pages** from the
Actions tab. The deployment workflow generates the public browser configuration.
The publishable key is intentionally visible to website visitors; the database
policies, not a secret key, restrict what visitors can do.

## Public upload note

Anyone with the website link can add images to the shared album. Uploads accept
JPG, PNG, WebP, or GIF, up to 8 MB each and five at a time. Visitors cannot
delete images through the website. Public uploads can use the project's storage
quota, so review the album and Supabase usage occasionally.
