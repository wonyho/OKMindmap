const axios = require('axios');

export default function () {
  return {
    frmdata: {},
    status: '',

    send: function (contactid) {
      if (this.status != 'sending') {
        this.status = 'sending';
        axios
          .post('api/contact.php', Object.assign({ contactid: contactid }, this.frmdata))
          .then((res) => {
            this.status = 'success';
          })
          .catch((error) => {
            this.status = 'failed';
          });
      }
    },
  };
}
