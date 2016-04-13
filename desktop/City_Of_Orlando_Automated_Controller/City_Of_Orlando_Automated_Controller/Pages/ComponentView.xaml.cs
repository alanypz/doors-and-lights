using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using FirstFloor.ModernUI.Windows.Controls;
using System.Windows.Resources;
using System.Threading;
using System.ComponentModel;
using City_Of_Orlando_Automated_Controller.HelperClasses;

namespace City_Of_Orlando_Automated_Controller.Pages
{
    /// <summary>
    /// Interaction logic for ComponentView.xaml
    /// </summary>
    public partial class ComponentView : UserControl, INotifyPropertyChanged
    {

        private bool _panelLoading;
        private string _panelMainMessage = "";
        private string _panelSubMessage = "";

        public ComponentView()
        {
            // init for the page
            InitializeComponent();

            // init for the doors/lights
            initializeComponents();

            // init refresh
            initializeRefresh();

            // Data Context
            DataContext = this;
        }

        void initializeComponents()
        {
            Component[] tempDoor = null;
            Component[] tempLight = null;

            //Get the doors
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(Utility.ip + "/status/door");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:door");
            var serializer = new JavaScriptSerializer();
            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();
                
                Utility.lrDoors = serializer.Deserialize<dynamic>(result);
                
                for(int i=0; i<Utility.lrDoors.Length; i++)
                {
                    Utility.lrDoors[i] = serializer.Serialize(Utility.lrDoors[i]);
                }

                tempDoor = new Component[Utility.lrDoors.Length];

                for(int i=0; i<Utility.lrDoors.Length; i++)
                {
                    tempDoor[i] = serializer.Deserialize<Component>(Utility.lrDoors[i].ToString());
                }

                tempDoor = tempDoor.OrderBy(x => x.number).ToArray();
                
            }

            //Get the lights
            httpWebRequest = (HttpWebRequest)WebRequest.Create(Utility.ip + "/status/light");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:light");
            httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                Utility.lrLights = serializer.Deserialize<dynamic>(result);

                for (int i = 0; i < Utility.lrLights.Length; i++)
                {
                    Utility.lrLights[i] = serializer.Serialize(Utility.lrLights[i]);
                }

                tempLight = new Component[Utility.lrLights.Length];

                for (int i = 0; i < Utility.lrLights.Length; i++)
                {
                    tempLight[i] = serializer.Deserialize<Component>(Utility.lrLights[i].ToString());
                }

                tempLight = tempLight.OrderBy(x => x.number).ToArray();
            }

            //Put them together
            Utility.components = new Component[Utility.lrDoors.Length + Utility.lrLights.Length];
            Utility.componentButtons = new Button[Utility.lrDoors.Length + Utility.lrLights.Length];
            
            for(int i=0; i< Utility.lrDoors.Length + Utility.lrLights.Length; i++)
            {
                if(i<Utility.lrDoors.Length)
                {
                    Utility.components[i] = tempDoor[i];
                    Utility.components[i].type = "Door";
                }

                else
                {
                    Utility.components[i] = tempLight[i - Utility.lrDoors.Length];
                    Utility.components[i].type = "Light";
                }
 
                Button newComponent = new Button();
                Thickness margin = newComponent.Margin;
                margin.Left = 5;
                margin.Right = 5;
                margin.Top = 9;

                Uri resourceUri = null;

                if (i < Utility.lrDoors.Length)
                {
                    if (i < 10)
                    {
                        newComponent.Content = " " + (i + 1).ToString();
                    }

                    else
                    {
                        newComponent.Content = (i + 1).ToString();
                    }

                    newComponent.Tag = "Door";

                    if(Utility.components[i].position == "raised")
                    {
                        resourceUri = new Uri("Images/garage_raised.png", UriKind.Relative);
                    }

                    else
                    {
                        resourceUri = new Uri("Images/garage_lowered.png", UriKind.Relative);
                    }
                    
                }

                else
                {
                    if (i < 10)
                    {
                        newComponent.Content = (i + 1 - Utility.lrDoors.Length).ToString();
                    }

                    else
                    {
                        newComponent.Content = (i + 1 - Utility.lrDoors.Length).ToString();
                    }
                    
                    newComponent.Tag = "Light";

                    if (Utility.components[i].position == "raised")
                    {
                        resourceUri = new Uri("Images/light_raised.png", UriKind.Relative);
                    }

                    else
                    {
                        resourceUri = new Uri("Images/light_lowered.png", UriKind.Relative);
                    }

                }

                var brush = new ImageBrush();
                StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                brush.ImageSource = temp;
                newComponent.HorizontalAlignment = HorizontalAlignment.Left;
                newComponent.VerticalAlignment = VerticalAlignment.Top;
                newComponent.HorizontalContentAlignment = HorizontalAlignment.Left;
                newComponent.VerticalContentAlignment = VerticalAlignment.Top;
                newComponent.Width = 75;
                newComponent.Height = 52;
                newComponent.Margin = margin;
                newComponent.Background = brush;
                newComponent.AddHandler(Button.ClickEvent, new RoutedEventHandler(button_Click));
                Utility.componentButtons[i] = newComponent;

                if (i < Utility.lrDoors.Length)
                {
                    ugDoor.Children.Add(newComponent);
                }

                else
                {
                    ugLight.Children.Add(newComponent);
                }
            }

           
        }

        void initializeRefresh()
        {
            var brush = new ImageBrush();
            Uri resourceUri = new Uri("Images/refresh.png", UriKind.Relative);
            StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
            BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
            brush.ImageSource = temp;
            refresh.Background = brush;
        }

        void button_Click(object sender, EventArgs e)
        {

            refresh.IsEnabled = false;

            Button selectedComponent = (Button)sender;

            Utility.componentIndex = Int32.Parse(selectedComponent.Content.ToString()) - 1;

            if((string)selectedComponent.Tag == "Light")
            {
                Utility.componentIndex += Utility.lrDoors.Length;
            }

            selectedComponent = Utility.componentButtons[Utility.componentIndex];

            Component component = Utility.components[Utility.componentIndex];

            ModernDialog commandView = new CommandView(component, this);
            commandView.Buttons = new Button[] { commandView.CloseButton };
            commandView.ShowDialog();

            if (PanelLoading)
            {
                disableButtons();
            }

            else
            {
                refresh_Click(null, null);
            }

        }

        public void disableButtons()
        {
            for(int i=0; i<Utility.componentButtons.Length; i++)
            {
                if (i != Utility.componentIndex)
                {
                    Utility.componentButtons[i].IsEnabled = false;
                }
            }
        }

        public void enableButtons()
        {
            for (int i = 0; i < Utility.componentButtons.Length; i++)
            {
                Utility.componentButtons[i].IsEnabled = true;
            }
        }

        public void refresh_Click(object sender, RoutedEventArgs e)
        {

            refresh.Cursor = Cursors.Wait;

            Component[] tempDoor = null;
            Component[] tempLight = null;

            //Get the doors
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(Utility.ip + "/status/door");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:door");
            var serializer = new JavaScriptSerializer();
            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                Utility.lrDoors = serializer.Deserialize<dynamic>(result);

                for (int i = 0; i < Utility.lrDoors.Length; i++)
                {
                    Utility.lrDoors[i] = serializer.Serialize(Utility.lrDoors[i]);
                }

                tempDoor = new Component[Utility.lrDoors.Length];

                for (int i = 0; i < Utility.lrDoors.Length; i++)
                {
                    tempDoor[i] = serializer.Deserialize<Component>(Utility.lrDoors[i].ToString());
                }

                tempDoor = tempDoor.OrderBy(x => x.number).ToArray();

            }

            //Get the lights
            httpWebRequest = (HttpWebRequest)WebRequest.Create(Utility.ip + "/status/light");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:light");
            httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                Utility.lrLights = serializer.Deserialize<dynamic>(result);

                for (int i = 0; i < Utility.lrLights.Length; i++)
                {
                    Utility.lrLights[i] = serializer.Serialize(Utility.lrLights[i]);
                }

                tempLight = new Component[Utility.lrLights.Length];

                for (int i = 0; i < Utility.lrLights.Length; i++)
                {
                    tempLight[i] = serializer.Deserialize<Component>(Utility.lrLights[i].ToString());
                }

                tempLight = tempLight.OrderBy(x => x.number).ToArray();
            }

            //Put them together
            for (int i = 0; i < tempDoor.Length + tempLight.Length; i++)
            {
                Uri resourceUri = null;

                if (i < tempDoor.Length)
                {
                    Utility.components[i] = tempDoor[i];
                    Utility.components[i].type = "Door";

                    if (Utility.components[i].position == "raised")
                    {
                        resourceUri = new Uri("Images/garage_raised.png", UriKind.Relative);
                        var brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[i].Background = brush;
                    }

                    else
                    {
                        resourceUri = new Uri("Images/garage_lowered.png", UriKind.Relative);
                        var brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[i].Background = brush;
                    }
                }

                else
                {
                    Utility.components[i] = tempLight[i-tempDoor.Length];
                    Utility.components[i].type = "Light";

                    if (Utility.components[i].position == "raised")
                    {
                        resourceUri = new Uri("Images/light_raised.png", UriKind.Relative);
                        var brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[i].Background = brush;
                    }

                    else
                    {
                        resourceUri = new Uri("Images/light_lowered.png", UriKind.Relative);
                        var brush = new ImageBrush();
                        StreamResourceInfo streamInfo = Application.GetResourceStream(resourceUri);
                        BitmapFrame temp = BitmapFrame.Create(streamInfo.Stream);
                        brush.ImageSource = temp;
                        Utility.componentButtons[i].Background = brush;
                    }
                }
            }

            if (sender != null)
            {
                ModernDialog.ShowMessage("Components Successfully Updated", "Update", MessageBoxButton.OK, null);
            }

        }

        private void refresh_MouseEnter(object sender, MouseEventArgs e)
        {
            refresh.Cursor = Cursors.Hand;
        }

        private void refresh_MouseLeave(object sender, MouseEventArgs e)
        {
            refresh.Cursor = Cursors.Arrow;
        }

        //New Stuff
        ///////////////////////////////////////////////////////////////////////////////////////////
        /// <summary>
        /// Occurs when a property value changes.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        /// <summary>
        /// Gets or sets a value indicating whether [panel loading].
        /// </summary>
        /// <value>
        /// <c>true</c> if [panel loading]; otherwise, <c>false</c>.
        /// </value>
        public bool PanelLoading
        {
            get
            {
                return _panelLoading;
            }
            set
            {
                _panelLoading = value;
                RaisePropertyChanged("PanelLoading");
            }
        }

        /// <summary>
        /// Gets or sets the panel main message.
        /// </summary>
        /// <value>The panel main message.</value>
        public string PanelMainMessage
        {
            get
            {
                return _panelMainMessage;
            }
            set
            {
                _panelMainMessage = value;
                RaisePropertyChanged("PanelMainMessage");
            }
        }

        /// <summary>
        /// Gets or sets the panel sub message.
        /// </summary>
        /// <value>The panel sub message.</value>
        public string PanelSubMessage
        {
            get
            {
                return _panelSubMessage;
            }
            set
            {
                _panelSubMessage = value;
                RaisePropertyChanged("PanelSubMessage");
            }
        }

        /// <summary>
        /// Gets the panel close command.
        /// </summary>
        public ICommand PanelCloseCommand
        {
            get
            {
                return new DelegateCommand(() =>
                {
                    // Your code here.
                    // You may want to terminate the running thread etc.
                    PanelLoading = false;
                });
            }
        }

        /// <summary>
        /// Gets the show panel command.
        /// </summary>
        public ICommand ShowPanelCommand
        {
            get
            {
                return new DelegateCommand(() =>
                {
                    PanelLoading = true;
                });
            }
        }

        /// <summary>
        /// Gets the hide panel command.
        /// </summary>
        public ICommand HidePanelCommand
        {
            get
            {
                return new DelegateCommand(() =>
                {
                    PanelLoading = false;
                });
            }
        }

        /// <summary>
        /// Gets the change sub message command.
        /// </summary>
        public ICommand ChangeSubMessageCommand
        {
            get
            {
                return new DelegateCommand(() =>
                {
                    PanelSubMessage = string.Format("Message: {0}", DateTime.Now);
                });
            }
        }

        /// <summary>
        /// Raises the property changed.
        /// </summary>
        /// <param name="propertyName">Name of the property.</param>
        protected void RaisePropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

    }
}
