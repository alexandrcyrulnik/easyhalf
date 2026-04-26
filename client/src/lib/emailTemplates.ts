import type { PlanType } from "@shared/schema";

const getEmailStyles = () => `
.ExternalClass {width:100%;}
img{ border:0 none; height:auto; line-height:100%; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic; }
a img{ border:0 none; }
#outlook a {padding:0;}
#allrecords{ height:100% !important; margin:0; padding:0; width:100% !important; -webkit-font-smoothing: antialiased; line-height: 1.45; }
#allrecords td{ margin:0; padding:0; }
#allrecords ul{-webkit-padding-start:30px;}
.t-records ol, .t-records ul{ padding-left: 20px; margin-top: 0px; margin-bottom: 10px; }
@media only screen and (max-width: 600px) { .r{ width:100% !important; min-width:400px !important; margin-top: -1px !important; } }
@media only screen and (max-width: 480px) { .t-emailBlock { display: block !important; padding-left: 0 !important; padding-right: 0 !important; width: 100% !important; } .t-emailBlockPadding { padding-top: 15px !important; } .t-emailBlockPadding30 { padding-top: 30px !important; } .t-emailAlignLeft { text-align: left !important; margin-left: 0 !important; } .t-emailAlignCenter { text-align: center !important; margin-left: auto !important; margin-right: auto !important; } }
`;

const getPlanEmailTemplate = (tokenUrl: string, buttonText: string) =>
  `<!DOCTYPE html><html><head><meta charset="utf-8"/><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><meta name="viewport" content="width=400"/><title></title><style type="text/css">${getEmailStyles()}</style></head><body style="padding:0;margin:0;background:#fff;"><table style="width:100%;max-width:600px;margin:0 auto;border-collapse:collapse;"><tr><td style="padding:30px;font-family:Helvetica Neue,Helvetica,Arial,sans-serif;"><div style="font-size:32px;font-weight:600;color:#222;">Your Training Plan is Ready!</div><div style="margin-top:15px;font-size:16px;color:#666;line-height:1.6;">Great news! Your personalized half marathon training plan has been created and is ready for you to start your journey.</div><div style="margin-top:25px;"><a href="${tokenUrl}" style="display:inline-block;padding:17px 36px;font-size:17px;font-weight:bold;color:#333;background:#ffe100;border-radius:3px;text-decoration:none;">${buttonText}</a></div><div style="margin-top:30px;font-size:14px;color:#8c8c8c;">If you have any questions, contact us at <a href="mailto:easyhalf.customers@gmail.com" style="color:#333;">easyhalf.customers@gmail.com</a></div></td></tr></table></body></html>`;

const getPaymentEmailTemplate = () =>
  `<!DOCTYPE html><html><head><meta charset="utf-8"/><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><meta name="viewport" content="width=400"/><title></title><style type="text/css">${getEmailStyles()}</style></head><body style="padding:0;margin:0;background:#fff;"><table style="width:100%;max-width:600px;margin:0 auto;border-collapse:collapse;"><tr><td style="padding:30px;font-family:Helvetica Neue,Helvetica,Arial,sans-serif;"><div style="font-size:32px;font-weight:600;color:#222;">Your Custom Plan is Ready!</div><div style="margin-top:15px;font-size:16px;color:#666;line-height:1.6;">Based on your quiz answers, we've created a personalized training plan. Complete your purchase to get instant access to your 12-week program.</div><div style="margin-top:25px;"><a href="https://buy.stripe.com/your-payment-link" style="display:inline-block;padding:17px 36px;font-size:17px;font-weight:bold;color:#333;background:#ffe100;border-radius:3px;text-decoration:none;">Complete Purchase</a></div><div style="margin-top:30px;font-size:14px;color:#8c8c8c;">Questions? Contact us at <a href="mailto:easyhalf.customers@gmail.com" style="color:#333;">easyhalf.customers@gmail.com</a></div></td></tr></table></body></html>`;

export const getPlanAccessEmail = (planType: PlanType) => {
  const subjects: Record<PlanType, string> = {
    "2:00": "Here is your half marathon plan! Good luck!",
    "1:45": "Here is your half marathon plan! Thank you and good luck!",
    "1:30": "Here is your half marathon plan! Good luck!",
  };
  const buttonTexts: Record<PlanType, string> = {
    "2:00": "Go to my plan",
    "1:45": "Go to my plan",
    "1:30": "Go To My Plan",
  };
  return {
    subject: subjects[planType],
    getBody: (tokenUrl: string) => getPlanEmailTemplate(tokenUrl, buttonTexts[planType]),
  };
};

export const paymentEmail = {
  subject: "🏃‍♂️ Pamela, your personal half marathon training plan has been generated!",
  getBody: () => getPaymentEmailTemplate(),
};
