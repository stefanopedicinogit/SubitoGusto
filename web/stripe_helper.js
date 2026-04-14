// Stripe Payment Element helper for Flutter web integration
let stripeInstance = null;
let elements = null;
let paymentElement = null;

function initStripePayment(publishableKey, clientSecret, elementId) {
  stripeInstance = Stripe(publishableKey);
  elements = stripeInstance.elements({
    clientSecret: clientSecret,
    appearance: {
      theme: 'stripe',
      variables: {
        colorPrimary: '#722F37',
        colorBackground: '#FFFFFF',
        colorText: '#36454F',
        colorDanger: '#FF6B6B',
        fontFamily: 'Lato, system-ui, sans-serif',
        borderRadius: '8px',
        spacingUnit: '4px',
      },
      rules: {
        '.Input': {
          border: '1px solid #E0E0E0',
          boxShadow: 'none',
        },
        '.Input:focus': {
          border: '2px solid #D4AF37',
          boxShadow: 'none',
        },
      },
    },
    locale: 'it',
  });

  const container = document.getElementById(elementId);
  if (!container) {
    console.error('Stripe container not found:', elementId);
    return false;
  }

  paymentElement = elements.create('payment', {
    layout: {
      type: 'tabs',
      defaultCollapsed: false,
    },
  });
  paymentElement.mount(container);
  return true;
}

async function confirmStripePayment(returnUrl) {
  if (!stripeInstance || !elements) {
    return JSON.stringify({ error: 'Stripe not initialized' });
  }

  const { error } = await stripeInstance.confirmPayment({
    elements: elements,
    confirmParams: {
      return_url: returnUrl,
    },
    redirect: 'if_required',
  });

  if (error) {
    return JSON.stringify({ error: error.message });
  }

  return JSON.stringify({ success: true });
}

function destroyStripePayment() {
  if (paymentElement) {
    paymentElement.destroy();
    paymentElement = null;
  }
  elements = null;
  stripeInstance = null;
}
