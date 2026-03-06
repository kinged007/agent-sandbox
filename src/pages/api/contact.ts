import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request, redirect }) => {
  const data = await request.formData();
  const name = data.get('name')?.toString().trim() ?? '';
  const email = data.get('email')?.toString().trim() ?? '';
  const company = data.get('company')?.toString().trim() ?? '';
  const message = data.get('message')?.toString().trim() ?? '';

  // Basic validation
  if (!name || !email || !message) {
    return new Response(
      JSON.stringify({ error: 'Name, email and message are required.' }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    );
  }

  // Email format check
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return new Response(
      JSON.stringify({ error: 'Please provide a valid email address.' }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    );
  }

  // Log the enquiry server-side (replace with email/CRM integration as needed)
  console.log('[Contact Enquiry]', {
    timestamp: new Date().toISOString(),
    name,
    email,
    company,
    message,
  });

  // Redirect to thank-you page
  return redirect('/thank-you', 302);
};
